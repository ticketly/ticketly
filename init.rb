module Heroku::Command
  class Tikt < BaseWithApp
    def list
      display "called tikt::list"
    end
    
    alias :index :list
  end
end