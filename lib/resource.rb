module Heroku::Command
  class Ticketly
    def rest_err(die=true)
      begin
        return [:success, yield]
      rescue RestClient::Unauthorized => e
        die ? error("Authentication failure:\n" + e.http_body) : [:unauthorized, e.http_body]
      rescue RestClient::ResourceNotFound => e
        die ? error("Not found::\n" + e.http_body) : [:not_found, e.http_body]
      rescue RestClient::RequestFailed => e
        if e.http_code == 400
          die ? error("Bad request:\n" + e.http_body) : [:bad_request, e.http_body]
        elsif e.http_code < 500
          die ? error("Client error:\n" + e.http_body) : [:bad_request, e.http_body]
        else
          die ? error("Request failed: internal server error\n") : [:server_error, e.http_body]
        end
      rescue RestClient::RequestTimeout
        error "API request timed out. Please try again, or contact support@tikt.ly if this issue persists."
      rescue RestClient::Exception => e
        error("Request failed:\n" + e.http_body)
      rescue Interrupt => e
        error "\n[canceled]"
      end
    end
    
    protected
    def resource(uri)
      if uri =~ /^https?/
        RestClient::Resource.new(uri, user, password)
      else
        host = API_PRE + @app + '.' + API_HOST
        uri = "/api/" + uri unless uri =~ /^\//
        parts = uri.split('?')
        parts[0] << '.json' unless parts[0] =~ /\.json$/
        uri = parts.join('?')
        RestClient::Resource.new(host, user, password)[uri]
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

    def create_url(base, options)
      url = base.dup
      unless options.empty?
        url << '?'
        first = true
        options.each do |k, v|
          if v
            url << "&" unless first
            url << "#{k}=#{v}"
            first = false
          end
        end
      end
      url.gsub(' ', '+')
    end
    
    def process(method, uri, extra_headers={}, payload=nil)
      headers  = tix_headers.merge(extra_headers)
      args     = [method, payload, headers].compact
      response = resource(uri).send(*args)
      
      text = response.to_s
      js = json(text)
      display(js["warning"]) if js["warning"]
      return js
    end
    
    def json(resp)
      JSON.parse(resp)
    end

    def tix_headers   # :nodoc:
      {
        'X-Tikt-API-Version' => '1',
        'User-Agent'           => 'tix-heroku-plugin',
        'X-Ruby-Version'       => RUBY_VERSION,
      }
    end
  end
end