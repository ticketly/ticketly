require 'pp'

module Heroku::Command
  class Tix < BaseWithApp
    include Heroku::PluginInterface
    
    def initialize(args, heroku=nil)
      super(args, heroku)
      verify_auth
    end
  end
end

API_PRE = "http://"
API_HOST = "ticketly.dev:3000"

require 'help'
require 'resource'
require 'ticket'
require 'auth'