require "dotenv/load"

Dotenv.load

module WorkshopOop
  class WeatherError < StandardError; end

  class BasicService
    attr_reader :http_client, :options
    def initialize http_client, **options
      @http_client = http_client
      @options = options
    end

    def self.build **options
      http_client =  -> uri { open(uri).read }
      new(http_client, **options)
    end
  end

  class OpenWeatherMapCast < BasicService
    def by_location location_name
      uri = URI.parse("http://samples.openweathermap.org/data/2.5/weather?q=#{location_name},uk&appid=#{options[:app_id]}")
      response_body = http_client.call(uri)
      JSON.parse response_body, symbolize_names: true
    end
  end

  class MetaWeatherCast < BasicService
    def by_location location_name
      uri = URI.parse("https://www.metaweather.com/api/location/search/?query=#{location_name}")
      response_body = http_client.call(uri)
      locations = JSON.parse response_body, symbolize_names: true
      location_id = locations.first[:woeid]

      uri = URI.parse("https://www.metaweather.com/api/location/#{location_id}/")
      response_body = http_client.call(uri)
      JSON.parse response_body, symbolize_names: true
    end
  end

  WEATHER_SERVICES = \
    {
      "openweathermap" => OpenWeatherMapCast.build(app_id: ENV["OPENWEATHERMAP_APP_ID"]),
      "metaweather" => MetaWeatherCast.build
    }

  class WeatherCast
    attr_reader :weather_services
    def initialize weather_services = WEATHER_SERVICES
      @weather_services = weather_services
    end

    def by_location location, service_name: "metaweather"
      weather_service = weather_services[service_name]
      raise WorkshopOop::WeatherError, "Unknow service name, available names: openweathermap, metaweather" unless weather_service

      weather_service.by_location location
    end
  end
end
