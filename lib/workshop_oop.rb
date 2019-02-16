require "workshop_oop/version"
require "open-uri"
require "json"
require "ostruct"

module WorkshopOop
  class Error < StandardError; end

  def self.make_geo_request
    -> ip_address = nil {
      uri = URI.parse("http://ip-api.com/json/#{ip_address}")
      uri.read
    }
  end

  def self.parse_json
    -> json { JSON.parse json, symbolize_names: true }
  end

  def self.get_geo(ip_address = nil, geo_service: make_geo_request, parser: parse_json)
    response = geo_service.call(ip_address)
    parser.call(response)
  end
end
