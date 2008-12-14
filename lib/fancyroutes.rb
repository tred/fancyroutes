module FancyRoutes
  class Route
    
    class << self
      def copy(map,segments,controller,action)
        copy = Route.new(map)
        copy.segments = segments.dup unless segments.nil?
        copy.controller(controller.dup) unless controller.nil?
        copy.action(action.dup) unless action.nil?
        copy
      end
    end
    
    def initialize(map)
      @map = map
      @segments = []
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
        c = copy
        c.request_method(verb.to_sym)
        c
      end
    end
    
    def with
      self
    end
    
    def match(&blk)
      instance_eval &blk
    end
        
    def create
      @map.connect(segments, 
        :controller => @controller,
        :action => @action,
        :conditions => { :method => @request_method })
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
    
    def copy
      Route.copy @map, @segments, @controller, @action
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