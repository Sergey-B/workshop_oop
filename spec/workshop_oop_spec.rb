require "workshop_oop"

RSpec.describe WorkshopOop do
  let(:ip_address) { "134.234.3.2" }
  let(:geo_data) {
    {
      as: "AS1586 DoD Network Information Center",
      city: "Sierra Vista",
      country: "United States",
      countryCode: "US",
      isp: "DoD Network Information Center",
      lat: 31.5552,
      lon: -110.35,
      org: "USAISC",
      query: "134.234.3.2",
      region: "AZ",
      regionName: "Arizona",
      status: "success",
      timezone: "America/Phoenix",
      zip: "85613"
    }
  }
  let(:geo_service) {
    double("GeoService", call: geo_data)
  }

  let(:workshop_lib) {
    WorkshopOop::GetGeoService.build(geo_service)
  }

  it "has a version number" do
    expect(WorkshopOop::VERSION).not_to be nil
  end

  it "returns geo data" do
    expect(workshop_lib.get_geo(ip_address)).to eq geo_data
  end

  context "when ip_address is absent" do
    it "returns self ip geo data" do
      expect(workshop_lib.get_geo).to eq geo_data
    end
  end
end
