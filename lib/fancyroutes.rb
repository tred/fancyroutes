module FancyRoutes

  class Route

    def initialize
      @segments = []
    end

    def request_method(method)
      @request_method = method.to_sym
      self
    end

    %w(get put post delete).each do |meth|
      define_method(meth) { request_method(meth) }
    end

    attr_writer :name

    def segment(segment)
      segment = case segment
        when Symbol
          ":#{segment}"
        when Hash
          self.send(segment.values.first, segment.keys.first)
          segment.keys.first.to_s
        else
          segment.to_s
        end
      @segments << segment
      self
    end
    alias_method :/, :segment

    def controller(controller)
      @controller = controller.to_s
      self
    end
    alias_method :>>, :controller

    def action(action)
      @action = action.to_s
      self
    end
    alias_method :>, :action

    def apply(rails_map)
      rails_map.send( (@name ? @name : :connect),
        @segments.join("/"), {
          :controller => @controller.try(:underscore),
          :action => @action.try(:underscore),
          :conditions => { :method => @request_method }
        }
      )
    end

    # hacky deep clone
    def copy
      Marshal::load(Marshal.dump(self))
    end

  end

  class RootRoute < Route

    def apply(rails_map)
      rails_map.root :controller => @controller,
                     :action => @action,
                     :conditions => { :method => @request_method }
    end

  end

  # may be clearer to use 3 classes here: RouteSet, MasterSet & NestedSet

  class RouteSet

    attr_reader :routes

    def initialize(template_route = nil)
      @template_route = template_route
      @routes = []
    end

    def apply(rails_route_map)
      @routes.each { |route| route.apply(rails_route_map) }
    end

    # builds a new route
    def route(meth = nil, name = nil)
      route = @template_route ? @template_route.copy : (name == :root ? RootRoute.new : Route.new)
      route.request_method(meth) if meth
      route.name = name if name
      @routes << route
      route
    end

    %w(get put post delete).each do |meth|
      define_method(meth) { route(meth) }
    end

    def root
      route(:get, :root)
    end

    def method_missing(meth,*args)
      route(nil,meth)
    end

    def with(route, &blk)
      # this route is used as a template, not as an actual route so we remove
      # it from the routes collection
      @routes.pop
      nested_set = self.class.new(route)
      nested_set.instance_eval(&blk)
      @routes += nested_set.routes
    end

  end

end

def FancyRoutes(m, &blk)
  fr = FancyRoutes::RouteSet.new
  fr.instance_eval(&blk)
  fr.apply(m)
end