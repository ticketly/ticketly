module Heroku::Command
  class Tikt
    include Heroku::PluginInterface
    
    def list
      display "called tikt::list"
    end
    
    alias :index :list
    
    
    def resource(uri)
      if uri =~ /^https?/
        RestClient::Resource.new(uri, user, password)
      else
        RestClient::Resource.new("https://api.#{host}", user, password)[uri]
      end
    end

    def get(uri, extra_headers={})    # :nodoc:
      process(:get, uri, extra_headers)
    end

    def post(uri, payload="", extra_headers={})    # :nodoc:
      process(:post, uri, extra_headers, payload)
    end

    def put(uri, payload, extra_headers={})    # :nodoc:
      process(:put, uri, extra_headers, payload)
    end

    def delete(uri, extra_headers={})    # :nodoc:
      process(:delete, uri, extra_headers)
    end

    def process(method, uri, extra_headers={}, payload=nil)
      headers  = tikt_headers.merge(extra_headers)
      args     = [method, payload, headers].compact
      response = resource(uri).send(*args)

      extract_warning(response)
      response
    end

    def json(resp)
      JSON.parse(resp.to_s)
    end
    
    def extract_warning(response)
      return unless response
    end

    def tikt_headers   # :nodoc:
      {
        'X-Tikt-API-Version' => '1',
        'User-Agent'           => 'tikt-heroku-plugin',
        'X-Ruby-Version'       => RUBY_VERSION,
      }
    end
    
  end

  Help.group 'Tikt Commands' do |group|
    group.command 'tikt:list', 'show tickets'
  end
end