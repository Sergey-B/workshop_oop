require "workshop_oop/version"
require "open-uri"
require "json"
require "yaml"

module WorkshopOop
  class Error < StandardError; end

  def self.make_geo_request
    -> ip_address = nil {
      uri = URI.parse("http://ip-api.com/json/#{ip_address}")
      response_body = open(uri).read

      JSON.parse response_body, symbolize_names: true
    }
  end

  class GeoIp
    attr_reader :geo_service

    def self.build geo_service = WorkshopOop.make_geo_request
      new(geo_service)
    end

    def initialize geo_service
      @geo_service = geo_service
    end

    def get_geo_by_ip ip_address = nil
      geo_service.call(ip_address)
    end

    def self.geo_by_ip ip_address = nil
      geo_ip = build
      geo_data = geo_ip.get_geo_by_ip(ip_address)
      geo_data.to_yaml
    end
  end
end
