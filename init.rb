module Heroku::Command
  class Tix < BaseWithApp
    include Heroku::PluginInterface
  end
end

require 'help'
require 'resource'
require 'ticket'