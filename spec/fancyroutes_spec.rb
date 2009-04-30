require File.dirname(__FILE__) + '/spec_helper'

describe "FancyRoutes" do
  
  before(:each) do
    @map = Object.new
  end

  # without helpers

  example "route on root, long form" do
    mock(@map).connect('', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => { :method => :get },
    })
    
    FancyRoutes(@map) do 
      route(:get).segment('').controller(:my_controller).action(:my_action)
    end
  end
  
  # an now lets dry up the mocking and route building
  
  def fancyroutes(&blk)
    FancyRoutes(@map,&blk)
  end

  def expect(meth, path, controller, action)
    mock(@map).connect(path, {
      :controller => controller,
      :action => action,
      :conditions => { :method => meth },
    })
  end

  example "short form route on root" do
    expect :get, '', 'my_controller', 'my_action'
    
    fancyroutes do
      get / '' >> :my_controller > :my_action
    end
  end
  
  example "short form route on order" do
    expect :get, ':slug/order', 'my_controller', 'my_action'
    
    fancyroutes do 
      get / :slug / 'order' >> :my_controller > :my_action
    end
  end
  
  example "short form route on order as put" do
    expect :put, ':slug/order', 'my_controller', 'my_action'
    
    fancyroutes do
      put / :slug / 'order' >> :my_controller > :my_action
    end
  end
  
  example "short form route nested route" do
    expect :get,  ':slug/order', 'my_controller', 'get_action'
    expect :post, ':slug/order', 'my_controller', 'post_action'
    
    fancyroutes do 
      with route / :slug >> :my_controller do
        get / 'order' > :get_action
        post / 'order' > :post_action
      end
    end
  end
  
  example "short form route nested route on method only" do
    expect :get,  ':slug/order', 'my_controller', 'get_action'
    expect :post, ':slug/order', 'my_controller', 'post_action'
    
    fancyroutes do
      with route / :slug / 'order' >> :my_controller do
        get > :get_action
        post > :post_action
      end
    end
  end
  
  example "nested in nested routes" do
    expect :get,  ':slug/order', 'my_controller', 'get_action'
    expect :post, ':slug/order', 'my_controller', 'post_action'
    
    fancyroutes do
      with route / :slug do
        with route >> :my_controller do
          get / 'order' > :get_action
          post / 'order' > :post_action
        end
      end
    end
  end
  
  example "with named segments" do
    expect :get, 'my_controller/my_action', 'my_controller', 'my_action'
    
    fancyroutes do 
      get / {'my_controller' => :controller} / {'my_action' => :action}
    end
  end
  
  example "with named segments using dashes" do
    expect :get, 'my-controller/my-action', 'my_controller', 'my_action'
    
    fancyroutes do 
      get / {'my-controller' => :controller} / {'my-action' => :action}
    end
  end
  
  example "with controller assumed from first segment" do
    expect :get, 'my_controller/my_action', 'my_controller', 'my_action'
    
    fancyroutes do
      get / "my_controller" / "my_action" > :my_action
    end
  end

  example "with controller assumed from first segment using dashes" do
    expect :get, 'my-controller/my_action', 'my_controller', 'my_action'
    
    fancyroutes do
      get / "my-controller" / { "my_action" => :action}
    end
  end
  
  example "a named route" do
    mock(@map).my_name('my_controller/:image', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => { :method => :get }
    })
    
    fancyroutes do 
      my_name.get / {'my_controller' => :controller} / :image > :my_action
    end
  end
  
  example "root route" do
    mock(@map).root(
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => { :method => :get }
    )
    
    fancyroutes do
      root >> :my_controller > :my_action
    end
  end
  
end