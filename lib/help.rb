module Heroku::Command

  Help.group 'Tiketly Commands' do |group|
    group.command 'tix:list', 'show tickets'
  end

end