module Heroku::Command
  class Tix
    protected
    
    def verify_auth
      get_credentials
    end
    
    def credentials_file
      "#{home_directory}/.heroku/plugins/ticketly/credentials"
    end
    
    def user    # :nodoc:
      get_credentials
      @credentials[0]
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

    def ask_for_credentials
      puts "Enter your Ticketly credentials."

      print "Email: "
      user = ask

      
      print "Password: "
      if command("auth:running_on_windows?")
        password = command("auth:ask_for_password_on_windows")
      else
        password = command("auth:ask_for_password")
      end
      
      [ user, password ]
    end

    def read_credentials
      File.exists?(credentials_file) and File.read(credentials_file).split("\n")
    end
    
    def save_credentials(credentials)
      begin
        write_credentials(credentials)
        #Heroku::Command.run_internal('keys:add', args)
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