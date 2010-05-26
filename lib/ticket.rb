module Heroku::Command
  class Tix
    def list
      display "called tix::list"
    end
    
    alias :index :list
  end
end