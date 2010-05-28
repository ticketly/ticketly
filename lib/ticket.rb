module Heroku::Command
  class Tix
    def list
      display "called tix::list"
      pp args
    end
    
    alias :index :list
  end
end