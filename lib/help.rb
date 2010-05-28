module Heroku::Command

  Help.group 'Tiketly Commands' do |group|
    group.command 'tix:list', 'show tickets'
  end

  class Tix
    def help
      puts "Help"
    end
  end
end