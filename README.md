Fancyroutes
===========

Fancyroutes is the first project from the TRED team. It has the following goals:

* Clean up route files
* Forget about rest out of the box (It's an API, build it as one)
* Provide building routes functionality
* Provide route linking functionality

Put your fancy routes into your routes file.

Example
=======

FancyRoutes(@map) do

  get / 'orders' >> :orders > 'index'
  
  with route / :slug >> :my_controller do
    get / 'order' > :my_action
    post / 'order' > :my_action
  end
  
  get / {'item_images' => :controller} / :image > :show
  
end

Copyright (c) 2008 TRED Team, released under the MIT license

Contributors
============

* Myles Byrne
* Carl Woodward
* Tim Lucas
* Chris Lloyd
* Michael Koukoullis
* Lincoln Stolli
* Dave Newman
