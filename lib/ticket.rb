module Heroku::Command
  class Ticketly
    def index
      all
    end

    def all
      sort, owner, state, tags = parse_cmd()
      list_tickets(sort, owner, state, tags)
    end
    
    def create
      params = {
        :ticket => {
          :title => extract_option("--title") || extract_option("-t"),
          :description => extract_option("--description") || extract_option("-d"),
          :state => extract_option("--state") || extract_option("-s"),
          :priority => extract_option("--priority") || extract_option("-p")
        },
        :label_list => (extract_option("--tags") || "").gsub(',', ' '),
        :user_email => extract_option("--owner")
      }
      
      error("Cant create a ticket without a title") unless params[:ticket][:title]
      ticket = post('/tickets/create', params)
      display("Ticket created:")
      display_tickets([ticket])
    end
    
    protected
    def parse_cmd()
      sort = extract_option("--sort")
      owner = extract_option("--owner")
      state = extract_option("--state") || extract_option("-s")
      tags = extract_option("--tag")
      
      return sort, owner, state, tags
    end
    
    def list_tickets(sort, owner, state, tags)
      url = create_url("tickets_list", {:sort => sort, :owner => owner, :state => state, :tags => tags})
      
      tickets = get(url)
      display_tickets(tickets["tickets"])
    end
    
    def longest_length(tickets, attribute)
      values = tickets.collect do |t| 
        t["ticket"][attribute].to_s
      end
      (values + [attribute]).flatten.collect{|s| s.size}.max
    end
    
    def print_to_length(str, l)
      print str
      (l - str.size + 3).times{print " "}
    end
    
    def display_tickets(tickets)
      attributes = ["id", "title", "priority", "n_comments", "n_votes", "updated", "tags"]
      lengths = {}
      attributes.each{|a| lengths[a] = longest_length(tickets, a)}
      
      if tickets.empty?
        display("No tickets found")
      else
        attributes.each{ |a| print_to_length(a, lengths[a])} # header
        puts
        lengths.values.inject(0){|ans, l| ans + l + 3}.times{print '-'}
        puts
        tickets.each do |tick|
          t = tick["ticket"]
          attributes.each do |a|
            print_to_length(t[a].to_s, lengths[a])
          end
          puts 
        end
      end
    end
  end
end