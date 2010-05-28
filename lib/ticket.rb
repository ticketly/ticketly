module Heroku::Command
  class Tix
    def list
      display "called tix::list"
      pp args
    end
    
    def index
      list
    end
  end
end