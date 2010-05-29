module Heroku::Command
  class Ticketly

    def auth_check(v=true)
      get("auth_check")
      display("Authorized") if v
    end
    
    def project_check
      get("project_check")
      display("Authorized")
    end

    def collaborator_sync
      list = heroku.list_collaborators(app).collect{|c| c[:email]}
      post("collaborator_sync", :emails => list.join(','))
      display("Syncing collaborators #{list.join(',')}")
    end

    protected
    def credentials_file
      "#{home_directory}/.heroku/plugins/ticketly/credentials"
    end
    
    def user    # :nodoc:
      command("auth:user")
    end

    def password    # :nodoc:
      get_credentials
      @credentials[1]
    end
    
    def get_credentials    # :nodoc:
      return if @credentials
      unless @credentials = read_credentials
        @credentials = ask_for_credentials
        save_credentials(@credentials)
      end
      @credentials
    end

    def ask_for_credentials(prompt = "Enter your Ticketly password (email=#{user}):")
      print prompt
      if command("auth:running_on_windows?")
        password = command("auth:ask_for_password_on_windows")
      else
        password = command("auth:ask_for_password")
      end
      
      [ user, password ]
    end
    
    def ask_create_user
      print "No ticketly user named #{user} found.  Create one? (Y/n):"
      ans = ask
      if ans.empty? or ans.downcase == 'y'
        u, p = ask_for_credentials("Please confirm your password:")
        if p == password
          begin
            post("user_create", {:user => {:email => user, :password => password, :password_confirmation => password}})
          rescue => e
            delete_credentials
            error("Unable to create user.\n" + e.http_body)
          end
        else
          delete_credentials
          error "passwords don't match"
        end
      end
    end

    def user_create
    end

    def read_credentials
      File.exists?(credentials_file) and File.read(credentials_file).split("\n")
    end
    
    def save_credentials(credentials)
      begin
        write_credentials(credentials)
        auth_check(false)
      rescue RestClient::ResourceNotFound => e
        ask_create_user
        retry
      rescue RestClient::Unauthorized => e
        delete_credentials
        display "\nAuthentication failed"
        @credentials = ask_for_credentials
        retry
      rescue Exception => e
        delete_credentials
        raise e
      end
    end
    
    def write_credentials(credentials)
      FileUtils.mkdir_p(File.dirname(credentials_file))
      File.open(credentials_file, 'w') do |f|
        f.puts credentials
      end

      FileUtils.chmod 0700, File.dirname(credentials_file)
      FileUtils.chmod 0600, credentials_file
    end

    def delete_credentials
      FileUtils.rm_f(credentials_file)
    end
    
  end
end