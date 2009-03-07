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
    expect :get,  ':slug/order', 'orders', 'show'
    expect :put, ':slug/order', 'orders', 'update'
    
    fancyroutes do 
      with route / :slug >> :orders do
        get / 'order' > :show
        put / 'order' > :update
      end
    end
  end
  
  example "short form route nested route on method only" do
    expect :get,  ':slug/order', 'my_controller', 'show'
    expect :put, ':slug/order', 'my_controller', 'update'
    
    fancyroutes do
      with route / :slug / 'order' >> :my_controller do
        get > :show
        put > :update
      end
    end
  end
  
  example "nested in nested routes" do
    expect :get,  ':slug/order', 'my_controller', 'my_action'
    expect :post, ':slug/order', 'my_controller', 'my_action'
    
    fancyroutes do
      with route / :slug do
        with route >> :my_controller do
          get / 'order' > :my_action
          post / 'order' > :my_action
        end
      end
    end
  end
  
  example "with named segment" do
    expect :get, 'item_images/:image', 'item_images', 'show'
    
    fancyroutes do 
      get / {'item_images' => :controller} / :image > :show
    end
  end
  
  example "a named route" do
    mock(@map).my_name('item_images/:image', {
      :controller => 'item_images',
      :action => 'show',
      :conditions => { :method => :get }
    })
    
    fancyroutes do 
      my_name.get / {'item_images' => :controller} / :image > :show
    end
  end
  
  example "root route" do
    mock(@map).root(
      :controller => 'homepage',
      :action => 'index',
      :conditions => { :method => :get }
    )
    
    fancyroutes do
      root >> :homepage > :index
    end
  end
  
end