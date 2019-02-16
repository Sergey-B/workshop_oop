require "workshop_oop/version"
require "open-uri"
require "json"

module WorkshopOop
  class Error < StandardError; end

  class GeoData
    attr_reader :http_request_service

    def self.build
      http_request_service =  -> uri { open(uri).read }
      new(http_request_service)
    end

    def initialize http_request_service
      @http_request_service = http_request_service
    end

    def by_ip ip_address = nil
      uri = URI.parse("http://ip-api.com/json/#{ip_address}")
      response_body = http_request_service.call(uri)
      JSON.parse response_body, symbolize_names: true
    end
  end
end
