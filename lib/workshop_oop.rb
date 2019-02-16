require "workshop_oop/version"
require "open-uri"
require "json"
require "ostruct"

module WorkshopOop
  class Error < StandardError; end

  def self.make_geo_request
    -> ip_address = nil {
      uri = URI.parse("http://ip-api.com/json/#{ip_address}")
      response_body = uri.read
      JSON.parse response_body, symbolize_names: true
    }
  end

  class GetGeoService
    attr_reader :geo_service

    def self.build geo_service = WorkshopOop.make_geo_request
      new(geo_service)
    end

    def initialize geo_service
      @geo_service = geo_service
    end

    def get_geo ip_address = nil
      geo_service.call(ip_address)
    end
  end
end
