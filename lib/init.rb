module Heroku::Command
  class Tix
    def init
      copy_bin
      help
    end
    
    private
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
  end
end