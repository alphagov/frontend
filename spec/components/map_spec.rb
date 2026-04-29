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
    expect(rendered).to have_selector(:css, "script", visible: :hidden, count: 3)
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
    expect(rendered).to have_css(".js-list-markers ol", visible: :hidden)
  end

  key = [
    {
      "name" => "Square",
      "symbol" => "square",
      "colour" => "red",
    },
    {
      "name" => "Pin",
      "symbol" => "pin",
      "colour" => "orange",
    },
  ]

  it "displays a key" do
    render_component(map_config: basic_config, heading: heading, key: key)
    expect(rendered).to have_css("h3.gem-c-heading__text", text: "Key")
    expect(rendered).to have_css(".govuk-list li", text: "Square")
    expect(rendered).to have_css(".govuk-list li:nth-child(1)", text: "Square")
    expect(rendered).to have_css(".govuk-list li:nth-child(1) .app-c-map__key--square.app-c-map__key--red")
    expect(rendered).to have_css(".govuk-list li:nth-child(2)", text: "Pin")
    expect(rendered).to have_css(".govuk-list li:nth-child(2) .app-c-map__key--pin.app-c-map__key--orange")
  end

  it "displays a custom key heading" do
    key_heading = { text: "Custom key heading", margin_bottom: 4, heading_level: 2, font_size: "xl" }
    render_component(map_config: basic_config, heading: heading, key: key, key_heading: key_heading)
    expect(rendered).to have_css(".gem-c-heading.govuk-\\!-margin-bottom-4")
    expect(rendered).to have_css("h2.gem-c-heading__text.govuk-heading-xl", text: "Custom key heading")
  end
end
