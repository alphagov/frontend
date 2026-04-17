RSpec.describe "MapComponent", type: :view do
  def component_name
    "map"
  end

  basic_config = {
    centre_lat: 55.9533,
    centre_lng: -3.1883,
    zoom: 12,
  }

  markers = [
    {
      lat: 51.5163,
      lng: -0.1766,
      description: "Designed by Isambard Kingdom Brunel and opened in 1838.",
      name: "Paddington Station",
    },
    {
      lat: 51.5316,
      lng: -0.1236,
      description: "Opened in 1852 and built on the site of a smallpox and fever hospital.",
      name: "Kings Cross station",
    },
  ]

  heading = { text: "heading" }

  it "renders nothing without config" do
    render_component({})
    expect(rendered).not_to have_css(".app-c-map")
  end

  it "renders the basic component" do
    render_component(map_config: basic_config, heading: heading)
    expect(rendered).to have_css(".app-c-map")
  end

  it "can have a custom heading" do
    render_component(map_config: basic_config, heading: { text: "A map showing areas of interest in Lower Chutney", heading_level: 1 })
    expect(rendered).to have_css(".gem-c-heading h1", text: "A map showing areas of interest in Lower Chutney")
  end

  it "can have a description" do
    render_component(map_config: basic_config, heading: heading, description: "what a map")
    expect(rendered).to have_css(".gem-c-govspeak", text: "what a map")
  end

  it "only includes the JavaScript tag once even if multiple component instances" do
    render_component(map_config: basic_config, heading: heading)
    render_component(map_config: basic_config, heading: heading)
    expect(rendered).to have_selector(:css, "script", visible: :hidden, count: 2)
  end

  it "can accept an array of markers" do
    render_component(markers: markers, heading: heading)
    expect(rendered).to have_css("[data-markers='#{markers.to_json}']")
  end

  it "accepts a geojson url" do
    geojson = "/fake/thing.geojson"
    render_component(url: geojson, heading: heading)
    expect(rendered).to have_css("[data-geojson='#{geojson}']")
  end

  it "can show a copyright message" do
    copyright = "This is copyright somebody, somewhere"
    render_component(map_config: basic_config, copyright: copyright, heading: heading)
    expect(rendered).to have_css(".app-c-map__copyright", text: copyright)
  end

  it "has a list for accessible markers" do
    render_component(markers: markers, heading: heading)
    expect(rendered).to have_css(".js-list-markers ul", visible: :hidden)
  end
end
