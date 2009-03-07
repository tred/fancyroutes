Fancyroutes
===========

Fancyroutes is a layer on top of the Rails routing system which provides an
elegant API for mapping requests to your application's controllers and
actions.

It provides all the Rails routing basics whilst removing the cruft, bringing the HTTP method to the forefront and support for DRYing up your routes via nesting.

The following were routes from one of Myles' applications:

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

Syntax
------

The `>>` operator indicates the controller and the `>` operator indicates the action.

The string segments, such as `'order'`, are just static bits of the URL path.

The symbol segments, such as `:image`, define parameters.

Please leave your parentheses in the naughty cupboard where they came from--fancyroutes' syntax was designed with Ruby's operator precedence in mind.

The root route
--------------

A standard root rout looks something like this:

    map.root :controller => 'homepage', :action => 'index'
    
The fancier version is:

    root >> :homepage > :index

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

Now you can generate the route:

    page_path(["help", "where-is-the-any-key"])

Nesting routes
--------------

Use `with route` to DRY up similar routes. For example:

    get / :slug / 'order' >> :orders > :show
    put / :slug / 'order' >> :orders > :update

can be rewritten as:

    with route / :slug / 'order' >> :orders do
      get > :show
      put > :update
    end

Installing
----------

Install the gem:

    sudo gem install tred-fancyroutes

add the dependency in your `environment.rb`:

    config.gem 'tred-fancyroutes'

and then use the `FancyRoutes` method in your `routes.rb`:

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