RSpec.describe "DownloadLinkComponent", type: :view do
  def component_name
    "download_link"
  end

  it "renders nothing when required params are not passed" do
    assert_empty render_component({})
    assert_empty render_component(text: "Download file")
    assert_empty render_component(href: "/download-link")
  end

  it "renders the component when link data is passed" do
    render_component(
      text: "Download file (DOC, 10KB)",
      href: "/download-file",
    )

    expect(rendered).to have_css(".app-c-download-link[href='/download-file']", text: "Download file (DOC, 10KB)")
  end

  it "renders the component with a calendar icon" do
    render_component(
      text: "Download calendar (ICS, 14KB)",
      href: "/download-calendar",
      icon: "calendar",
    )
    expect(rendered).to have_css(".app-c-download-link.app-c-download-link--calendar[href='/download-calendar']", text: "Download calendar (ICS, 14KB)")
  end

  it "renders the component with a title" do
    render_component(
      text: "Download file (DOC, 10KB)",
      href: "/download-file",
      title: "Download link title text",
    )
    expect(rendered).to have_css(".app-c-download-link[href='/download-file'][title='Download link title text']", text: "Download file (DOC, 10KB)")
  end

  it "renders the component with data attributes on the link" do
    render_component(
      text: "Download file (DOC, 10KB)",
      href: "https://www.gov.uk",
      link_data_attributes: {
        module: "test-module",
        link_info: "custom link data",
      },
    )

    expect(rendered).to have_css(".app-c-download-link[href='https://www.gov.uk']", text: "Download file (DOC, 10KB)")
    expect(rendered).to have_css(".app-c-download-link[data-module='test-module'][data-link-info='custom link data']")
  end
end
