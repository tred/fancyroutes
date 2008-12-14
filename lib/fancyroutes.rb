module FancyRoutes
  class Route
    def initialize(map, parent=nil)
      @map = map
      if parent
        @parent = parent
        %w(segments controller action request_method).each do |property|
          property_symbol = "@#{property}".to_sym
          if parent.instance_variable_get(property_symbol)
            instance_variable_set(property_symbol, 
                                  parent.instance_variable_get(property_symbol).dup)
          end
        end
      else
        @segments = []
      end
    end

    def request_method(method)
      @request_method = method.to_sym
      self
    end
    
    def segment(path_segment)
      @segments << path_segment
      self
    end
    alias_method :/, :segment
    
    def segments=(segments)
      @segments = segments
    end
    
    def controller(controller_name)
      @controller = controller_name.to_s
      self
    end
    alias_method :>>, :controller
    
    def action(action_name)
      @action = action_name.to_s
      self
    end
    alias_method :>, :action
    
    %w(get post put delete).each do |verb|
      define_method verb do
        r = Route.new(@map, self)
        r.request_method(verb.to_sym)
        r
      end
    end
    
    def with
      Route.new(@map, self)
    end
    
    def match(&blk)
      instance_eval &blk
    end
        
    def create
      @map.connect(segments, build_route_hash)
    end
    
    def method_missing(name, *args)
      @map.send(name, segments, build_route_hash)
    end
    
    protected
    
    def segments
      @segments = @segments.collect do |segment|
        case segment
        when String
          segment
        when Symbol
          (':' + segment.to_s)
        when Hash
          key, value = segment.keys.first, segment.values.first
          hash_segment key, value
        end 
      end.join('/')
    end
    
    def hash_segment(key,value)
      if value == :controller
        controller key
      elsif value == :action
        action key
      end
      key
    end
    
    def build_route_hash
      {
        :controller => @controller,
        :action => @action,
        :conditions => {:method => @request_method}
      }
    end
     
  end
  
  class RouteSet
    def initialize(map,&blk)
      @map = map
      route = Route.new map
      route.instance_eval &blk
    end
  end
end