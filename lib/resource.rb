module Heroku::Command
  class Tix
    protected
    def resource(uri)
      if uri =~ /^https?/
        RestClient::Resource.new(uri, user, password)
      else
        host = API_PRE + @app + '.' + API_HOST
        uri = "/api/" + uri unless uri =~ /^\//
        RestClient::Resource.new(host, user, password)[uri]
      end
    end

    def get!(uri, extra_headers={})    # :nodoc:
      process(:get, uri, extra_headers)
    end
    def get(uri, extra_headers={})    # :nodoc:
      rest_err(false){get!(uri, extra_headers)}
    end
    def post!(uri, payload="", extra_headers={})    # :nodoc:
      process(:post, uri, extra_headers, payload)
    end
    def post(uri, payload="", extra_headers={})    # :nodoc:
      rest_err(false){post!(uri, payload, extra_headers)}
    end
    def put!(uri, payload, extra_headers={})    # :nodoc:
      process(:put, uri, extra_headers, payload)
    end
    def put(uri, payload, extra_headers={})    # :nodoc:
      rest_err(false){put!(uri, payload, extra_headers)}
    end
    def delete!(uri, extra_headers={})    # :nodoc:
      process(:delete, uri, extra_headers)
    end
    def delete(uri, extra_headers={})    # :nodoc:
      rest_err(false){delete!(uri, extra_headers)}
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
    
    def rest_err(die=true)
      begin
        return [:success, yield]
      rescue RestClient::Unauthorized => e
        die ? error("Authentication failure:\n" + e.http_body) : [:unauthorized, e.http_body]
      rescue RestClient::ResourceNotFound => e
        die ? error("Not found::\n" + e.http_body) : [:not_found, e.http_body]
      rescue RestClient::RequestFailed => e
        die ? error("Request failed: internal server error\n") : [:server_error, e.http_body]
      rescue RestClient::RequestTimeout
        error "API request timed out. Please try again, or contact support@tikt.ly if this issue persists."
      rescue Interrupt => e
        error "\n[canceled]"
      end
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