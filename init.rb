require 'pp'

module Heroku::Command
  class Tix

    # public methods get called directly by heroku
    # protected methods get wrapped in rest_err to handle exceptions
    # private methods are not callable
    
    def initialize(args, heroku=nil)
      @ticketly = Ticketly.new(args, heroku)
    end
    
    def method_missing(sym, *args)
      #puts "method_missing:#{sym}"
      begin
        @ticketly.rest_err do
          @ticketly.send(sym)
        end
      rescue => e
        puts $!
        print e.backtrace.join("\n")
      end
    end
    
    def respond_to?(method)
      @ticketly.respond_to?(method)
    end
  end

  class Ticketly < BaseWithApp
    include Heroku::PluginInterface
    include Heroku::Helpers
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