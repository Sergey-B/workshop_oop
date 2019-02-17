require "open-uri"
require "json"

module WorkshopOop
  class GeoData
    attr_reader :http_client
    def self.build
      http_client =  -> uri { open(uri).read }
      new(http_client)
    end

    def initialize http_client
      @http_client = http_client
    end

    def by_ip ip_address = nil
      uri = URI.parse("http://ip-api.com/json/#{ip_address}")
      response_body = http_client.call(uri)
      JSON.parse response_body, symbolize_names: true
    end
  end
end
