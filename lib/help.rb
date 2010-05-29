module Heroku::Command

  Help.group 'Tiketly Commands' do |group|
    group.command 'tix:init', 'create username/password/initial project'    
    group.command 'tix:collaborator_sync', 'sync collaborators on this project'
    group.command 'tix', "see tix:all"
    group.command 'tix:all', "search for tickets (--sort, --owner, --state, --tags set these options)"
    group.command 'tix:create', "create a ticket (-t sets title, -d description, -s state, -p priority, --tags comma separated labels, --owner owner email)"
  end

  class Ticketly
    def help
      command("help")
    end
  end
end