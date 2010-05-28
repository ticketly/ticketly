module Heroku::Command
  class Tix
    def index
      list
    end

    protected
    def list
      display "called tix::list"
      pp args
    end
    
  end
end