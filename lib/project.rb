module Heroku::Command
  class Tix
    def create_project
      rest_err{post!("create_project")}
      display "Project #{@app} created"
    end  
  end
end