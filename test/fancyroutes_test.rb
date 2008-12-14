require "rubygems"
require "spec"
require File.expand_path(File.dirname(__FILE__) + "/../lib/fancyroutes")

Spec::Runner.configure do |config|
  config.mock_with :rr
end

describe "FancyRoutes" do
  
  before(:each) do
    @map = Object.new
    @fancyroutes = FancyRoutes::Route.new(@map)
  end

  example "route on root" do
    mock(@map).connect('', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => { :method => :get },
    })
    
    @fancyroutes.request_method(:get).segment('').controller(:my_controller).action(:my_action).create
  end  

  example "short form route on root" do
    mock(@map).connect('', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => { :method => :get },
    })
    
    (@fancyroutes.get / '' >> :my_controller > :my_action).create
  end
  
  example "short form route on order" do
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :get}
    })
    
    (@fancyroutes.get / :slug / 'order' >> :my_controller > :my_action).create
  end
  
  example "short form route on order as post" do
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :post}
    })
    
    (@fancyroutes.post / :slug / 'order' >> :my_controller > :my_action).create
  end
  
  example "short form route nested route" do
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :get}
    })
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :post}
    })
    
    (@fancyroutes.with / :slug >> :my_controller).match do
      (get / 'order' > :my_action).create
      (post / 'order' > :my_action).create
    end 
  end
  
  example "nested in nested routes" do
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :get}
    })
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :post}
    })
    
    (@fancyroutes.with / :slug).match do
      (with >> :my_controller).match do
        (get / 'order' > :my_action).create
        (post / 'order' > :my_action).create
      end
    end 
  end
  
  example "testing route set" do
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :get}
    })
    mock(@map).connect(':slug/order', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => {:method => :post}
    })
    
    FancyRoutes::RouteSet.new(@map) do
      (with / :slug).match do
        (with >> :my_controller).match do
          (get / 'order' > :my_action).create
          (post / 'order' > :my_action).create
        end
      end
    end 
  end
  
  example "with hashes for controller" do
    mock(@map).connect('item_images/:image', {
      :controller => 'item_images',
      :action => 'show',
      :conditions => {:method => :get}
    })
    
    (@fancyroutes.get / {'item_images' => :controller} / :image > :show).create
  end
  
  example "with named routes" do
    mock(@map).image_path('item_images/:image', {
      :controller => 'item_images',
      :action => 'show',
      :conditions => {:method => :get}
    })
    
    (@fancyroutes.get / {'item_images' => :controller} / :image > :show).image_path
  end
  
end
