module Heroku::Command
  class Ticketly
    def init
      copy_bin
      create_user_project
      help
    end
    
    
    protected
    def copy_bin
      begin
        if File.directory?(bin_dir)
          dest = File.join(bin_dir, 'tix')
          FileUtils.cp File.join(File.dirname(__FILE__), '..', 'tix'), dest
          FileUtils.chmod 0755, dest
        end
      rescue => e
        puts "Not copying binary tix: " + $!
      end
    end
    
    def bin_dir
      '/usr/local/bin'
    end

    def create_user_project
      begin
        project_create
      rescue RestClient::Unauthorized => e #project exists
        project_check
      end
      collaborator_sync
    end
    
  end
end