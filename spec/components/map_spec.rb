RSpec.describe "MapComponent", type: :view do
  def component_name
    "map"
  end

  it "renders nothing without config" do
    render_component({})

    expect(rendered).not_to have_css(".app-c-map")
  end

  it "renders the basic component" do
    render_component(map_config: {
      centre_lat: 55.9533,
      centre_lng: -3.1883,
      zoom: 12,
    })

    expect(rendered).to have_css(".app-c-map")
  end
end
