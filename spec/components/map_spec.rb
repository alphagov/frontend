RSpec.describe "MapComponent", type: :view do
  def component_name
    "map"
  end

  basic_config = {
    centre_lat: 55.9533,
    centre_lng: -3.1883,
    zoom: 12,
  }.freeze

  it "renders nothing without config" do
    render_component({})
    expect(rendered).not_to have_css(".app-c-map")
  end

  it "renders the basic component" do
    render_component(map_config: basic_config)
    expect(rendered).to have_css(".app-c-map")
  end

  it "can accept an array of markers" do
    markers = [
      {
        lat: 51.5163,
        lng: -0.1766,
        popupContent: "Paddington Station Designed by Isambard Kingdom Brunel and opened in 1838.",
        alt: "Paddington Station",
      },
      {
        lat: 51.5316,
        lng: -0.1236,
        popupContent: "Kings Cross Station Opened in 1852 and built on the site of a smallpox and fever hospital.",
        alt: "Kings Cross station",
      },
    ]
    render_component(markers: markers)
    expect(rendered).to have_css("[data-markers='#{markers.to_json}']")
  end

  it "accepts a geojson url" do
    geojson = "/fake/thing.geojson"
    render_component(geojson: geojson)
    expect(rendered).to have_css("[data-geojson='#{geojson}']")
  end

  it "can have an alternative map marker" do
    marker = "pin"
    render_component(map_config: basic_config, marker: marker)
    expect(rendered).to have_css("[data-marker='#{marker}']")
  end

  it "can show a copyright message" do
    copyright = "This is copyright somebody, somewhere"
    render_component(map_config: basic_config, copyright: copyright)
    expect(rendered).to have_css(".app-c-map__copyright", text: copyright)
  end
end
