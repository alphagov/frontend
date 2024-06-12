describe "MetadataComponent", type: :view do
  def component_name
    "metadata"
  end

  it "fails to render when no parameters given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders the component when a date object is given" do
    render_component(last_updated: Date.parse("2-5-2008"))
    assert_select(".app-c-metadata", text: "Last updated: 2 May 2008")
  end
end
