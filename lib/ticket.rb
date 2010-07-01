module Heroku::Command
  class Ticketly
    def index
      all
    end

    def all
      sort = extract_option("--sort")
      owner = extract_option("--owner")
      state = extract_option("--state") || extract_option("-s")
      tags = extract_option("--tag")
      list_tickets(sort, owner, state, tags)
    end

    def search
      sort = extract_option("--sort")
      q = args.join(" ")
      search_tickets(q, sort)
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
    
    def show
      id = args[0]
      show_ticket(id)
    end
    
    protected
    
    def list_tickets(sort, owner, state, tags)
      url = create_url("tickets_list", {:sort => sort, :owner => owner, :state => state, :tags => tags})
      tickets = get(url)
      display_tickets(tickets["tickets"])
    end

    def search_tickets(q, sort)
      url = create_url("tickets_search", {:q => q, :sort => sort})
      tickets = get(url)
      display_tickets(tickets["tickets"])
    end
    
    def show_ticket(id)
      url = create_url("ticket_show", {:id => id})
      resp = get(url)
      display_full_ticket(resp['ticket'])
    end
    
    def longest_length(tickets, attribute)
      values = tickets.collect do |t| 
        t[attribute].to_s
      end
      (values + [attribute]).flatten.collect{|s| s.size}.max
    end
    
    def print_to_length(str, l)
      print str
      (l - str.size + 3).times{print " "}
    end
    
    def display_tickets(tickets)
      attributes = ["id", "title", "state", "priority", "num_comments", "num_votes", "updated_at", "owner", "labels"]
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
          attributes.each do |a|
            print_to_length(tick[a].to_s, lengths[a])
          end
          puts 
        end
      end
    end
    
    def display_full_ticket(ticket)
      display_tickets([ticket])
      puts "Created by:  " + ticket["creator"].to_s
      puts "Description: " + ticket["description"].to_s
      puts ticket["num_comments"].to_i.to_s + " comments:"
      ticket["comments"].each do |c|
        puts "\t#{c['user']} on #{c['created_at']}:"
        puts "\t#{c['text']}"
        puts "\t----------------------------"
      end
    end
  end
end