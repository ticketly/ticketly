module Heroku::Command
  class Ticketly
    def project_create
      post("project_create")
      display "Project #{@app} created"
    end
  end
end