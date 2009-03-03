$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'fancyroutes'

Spec::Runner.configure do |config|
  config.mock_with :rr
end
