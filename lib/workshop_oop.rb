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

  def self.get_geo(ip_address = nil, geo_service: make_geo_request)
    geo_service.call(ip_address)
  end
end
