RSpec.describe "SubscribeComponent", type: :view do
  def component_name
    "subscribe"
  end

  it "fails to render when no parameters given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders the component when link data is passed" do
    render_component(
      label: "label",
      url: "https://www.gov.uk",
      title: "title",
    )

    expect(rendered).to have_css(".app-c-subscribe a[href='https://www.gov.uk'][title='title']", text: "label")
  end

  it "renders the component with data attributes on the link" do
    render_component(
      label: "label",
      url: "https://www.gov.uk",
      title: "title",
      link_data_attributes: {
        module: "test-module",
        ok: "go",
      },
    )

    expect(rendered).to have_css(".app-c-subscribe a[href='https://www.gov.uk'][title='title']", text: "label")
    expect(rendered).to have_css(".app-c-subscribe a[data-module='test-module'][data-ok='go']")
  end
end
