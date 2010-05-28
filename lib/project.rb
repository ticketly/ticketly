module Heroku::Command
  class Tix
    protected
    def create_project
      post("create_project")
      display "Project #{@app} created"
    end  
  end
end