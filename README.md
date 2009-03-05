Fancyroutes
===========

Fancyroutes is the first project from the TRED team. It has the following goals:

* Clean up route files
* Forget about rest out of the box (It's an API, build it as one)
* Provide building routes functionality
* Provide route linking functionality


Usage
-----

To teach you how to use Fancyroutes, we're going to show you some conversions from Rails' current routes into Fancyroutes. Lets start with the default routes:

<pre><code>map.connect ':controller/:action/:id'
map.connect ':controller/:action/:id.:format'</code></pre>

with Fancyroutes that becomes much prettier:

<pre><code>get / :controller / :action / :id
get / :controller / :action / ':id.:format'</code></pre>

Fancyroutes was designed specifically for the route files the group were working on. Here is an example from Myles' app:

<pre><code>map.connect '/orders', :controller => 'orders', :action => 'index, :conditions => { :method => :get }

map.connect '/:slug/order', :controller => 'orders', :action => :show, :conditions => { :method => :get }
map.connect '/:slug/order', :controller => 'orders', :action => :create, :conditions => { :method => :post }

map.connect 'item_images/:image', :controller => 'item_images', :action => 'show', :conditions => { :method => :get }</code></pre>

Here is how we could re-write that with Fancyroutes:

<pre><code>get / 'orders' >> :orders > 'index'

with route / :slug >> :orders do
  get / 'order' > :show
  put / 'order' > :update
end

# Inline controller syntax
get / {'item_images' => :controller} / :image > :show</code></pre>

The `>>` syntax indicates the controller and the `>` syntax means the action. Another example from Chris' app:

<pre><code>map.connect '/playground/:action', :controller => 'playground'
map.connect '/admin/playground/:action', :controller => 'admin/playground'

map.root :controller => 'homepage', :action => 'index'

map.page '/*tree', :controller => 'pages', :action => 'show'</code></pre>

and with Fancyroutes:

<pre><code>get / {'playground' => :controller } / :action
get / {'admin/playground' => :controller } / :action

root >> :homepage > :index

page.get / '*tree' >> :pages > :show</code></pre>


Get It
------

It is distributed as a rubygem:

`sudo gem install tred-fancyroutes`

You can then `config.gem` from your `environment.rb`. You can also download and view the source from [Github](http://github.com/tred/fancyroutes).

To use it in your routes file you need to do this:

<pre><code>ActionController::Routing::Routes.draw do |map|
FancyRoutes(map) do
  ...
end
end</code></pre>


Contributors
------------

* Myles Byrne
* Carl Woodward
* Tim Lucas
* Chris Lloyd
* Michael Koukoullis
* Lincoln Stolli
* Dave Newman


License
-------

Copyright (c) 2008 The TRED Team

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
