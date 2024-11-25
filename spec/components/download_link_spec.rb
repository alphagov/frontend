RSpec.describe "DownloadLinkComponent", type: :view do
  def component_name
    "download_link"
  end

  it "fails to render a download link when no href is given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders the component when link data is passed" do
    render_component(href: "/download-me")
    expect(rendered).to have_css(".app-c-download-link[href=\"/download-me\"]")
  end

  it "renders a download link with custom link text correctly" do
    render_component(
      href: "/download-map",
      link_text: "Download this file",
    )
    expect(rendered).to have_css(".app-c-download-link[href=\"/download-map\"]", text: "Download this file")
  end
end
