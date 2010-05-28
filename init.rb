require 'pp'

module Heroku::Command
  class Tix < BaseWithApp
    include Heroku::PluginInterface
    include Heroku::Helpers

    # public methods get called directly by heroku
    # protected methods get wrapped in rest_err to handle exceptions
    # private methods are not callable
    def method_missing(sym, *args)
      if protected_methods.include?(sym.to_s)
        rest_err{self.send(sym)}
      else
        super.send(sym, args)
      end
    end
  end

  # allow heroku ticketly:command in addition to heroku tix:command
  class Ticketly < Tix
    def index
      help
    end
  end
end

API_PRE = "http://"
API_HOST = "ticketly.dev:3000"

require 'help'
require 'resource'
require 'ticket'
require 'auth'
require 'project'
require 'init'