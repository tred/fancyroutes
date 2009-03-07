FancyRoutes
===========

Removing the cruft, bringing the HTTP method to the forefront and sporting a
neat DRYing block syntax--FancyRoutes is a layer on top of the Rails routing
system which provides an elegant API for mapping requests to your
application's controllers and actions.

Take for example the following routes from one of Myles' applications:

    map.connect '/orders', :controller => 'orders', :action => 'index, :conditions => { :method => :get }

    map.connect '/:slug/order', :controller => 'orders', :action => :show, :conditions => { :method => :get }
    map.connect '/:slug/order', :controller => 'orders', :action => :create, :conditions => { :method => :post }

    map.connect 'item_images/:image', :controller => 'item_images', :action => 'show', :conditions => { :method => :get }

Converted to fancyroutes these now look like:

    get / 'orders' >> :orders > :index

    with route / :slug / 'order' >> :orders do
      get > :show
      put > :update
    end
    
    get {'item_images' => :controller} / :image > :show

So fancy!

Where'd all the parentheses go?
-------------------------------

We use three of Ruby's operators to define paths:

* `/` separates the segments
* `>>` indicates the controller
* `>` indicates the action

Segments of the path can be strings or symbols. Symbols, such as `:image`, define parameters and strings, such as `'order'`, define static segments.

Controller names in the path
----------------------------

Quite often the controller name will already be in the path itself.

    map.connect '/playground/:action', :controller => 'playground'

Don't repeat yourself! Provide a hash instead:

    get / {'playground' => :controller} / :action

Named routes
------------

Simply suffix the get/post/put/delete with the name:

    page.get / '*tree' >> :pages > :show

Now you can generate a path with the route:

    page_path(["help", "where-is-the-any-key"])

Nesting routes
--------------

Use `with route` to DRY up similar routes. For example:

    get / :slug / 'order' >> :orders > :show
    put / :slug / 'order' >> :orders > :update

can be rewritten as:

    with route / :slug >> :orders do
      get / 'order' > :show
      put / 'order' > :update
    end

or even better:

    with route / :slug / 'order' >> :orders do
      get > :show
      put > :update
    end

The root route
--------------

A standard root route looks something like this:

    map.root :controller => 'homepage', :action => 'index'

The fancier version is:

    root >> :homepage > :index

Installing
----------

Install the gem:

    sudo gem install tred-fancyroutes

add the dependency in your environment.rb:

    config.gem 'tred-fancyroutes'

and then use the FancyRoutes method in your routes.rb:

    ActionController::Routing::Routes.draw do |map|
    FancyRoutes(map) do
      # the
      # fanciest
      # routes
      # you
      # ever
      # did
      # see
    end
    end

Contributors
------------

* Myles Byrne
* Carl Woodward
* Tim Lucas
* Chris Lloyd
* Michael Koukoullis
* Lincoln Stolli
* Dave Newman

License (MIT)
-------------

Copyright (c) 2008-09 The TRED Team

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.