require "workshop_oop/version"
require "open-uri"
require "json"
require "yaml"

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
      geo_data = JSON.parse response_body, symbolize_names: true
      geo_data.to_yaml
    rescue OpenURI::HTTPError, JSON::JSONError => error
      error
    end
  end
end
