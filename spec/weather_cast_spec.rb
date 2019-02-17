RSpec.describe WorkshopOop::WeatherCast do
  let(:city_name) {
    "Berlin"
  }
  let(:openweathermap_cast) {
    {
      service: "openweathermap"
    }
  }
  let(:metaweather_cast) {
    {
      service: "metaweather"
    }
  }
  let(:metaweather_location_data) {
    [
      {
        title: "Berlin",
        location_type: "City",
        woeid:  638242,
        latt_long: "52.516071,13.376980"
      }
    ]
  }
  let(:fake_http_client) {
    -> uri {
      case uri.to_s
      when /metaweather.com.*\/search.*/
        metaweather_location_data.to_json
      when /.*metaweather.com.*/
        metaweather_cast.to_json
      when /.*openweathermap.org.*/
        openweathermap_cast.to_json
      end
    }
  }
  let(:weather_services) {
    {
      "openweathermap" => WorkshopOop::OpenWeatherMapCast.new(fake_http_client),
      "metaweather" => WorkshopOop::MetaWeatherCast.new(fake_http_client)
    }
  }
  let(:weather_cast_service) {
    WorkshopOop::WeatherCast.new(weather_services)
  }

  it "returns weather cast from openweathermap" do
    expect(weather_cast_service.by_location(city_name, service_name: "openweathermap")).to eq openweathermap_cast
  end

  it "returns weather cast from metaweather" do
    expect(weather_cast_service.by_location(city_name, service_name: "metaweather")).to eq metaweather_cast
  end
end
