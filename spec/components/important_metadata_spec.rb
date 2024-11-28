RSpec.describe "ImportantMetadataComponent", type: :view do
  def component_name
    "important_metadata"
  end

  it "does not render metadata when no data is given" do
    expect(render_component({})).to be_empty
  end

  it "does not render when an 'other' object is provided without any values" do
    expect(render_component(other: { From: [] })).to be_empty
    expect(render_component(other: { a: false, b: "", c: [], d: {}, e: nil })).to be_empty
  end

  it "renders a title when a title is provided" do
    render_component(
      title: "The release date has been changed",
      items: {
        "Release Date": "14 October 2016",
      },
    )

    expect(rendered).to have_css(".app-c-important-metadata__title", text: "The release date has been changed")
  end

  it "renders metadata link pairs from data it is given" do
    render_component(items: {
      "Opened": "14 October 2016",
      "Case type": ['<a href="https://www.gov.uk/cma-cases?case_type%5B%5D=mergers">Mergers</a>'],
      "Case state": ['<a href="https://www.gov.uk/cma-cases?case_state%5B%5D=open">Open</a>'],
      "Market sector": ['<a href="https://www.gov.uk/cma-cases?market_sector%5B%5D=motor-industry">Motor industry</a>'],
      "Outcome": ['<a href="https://www.gov.uk/cma-cases?outcome_type%5B%5D=mergers-phase-2-clearance-with-remedies">Mergers - phase 2 clearance with remedies</a>'],
    })

    expect(rendered).to have_css(".app-c-important-metadata dt", text: "Opened:")
    expect(rendered).to have_css(".app-c-important-metadata dd", text: "14 October 2016")
    expect(rendered).to have_css(".app-c-important-metadata dt", text: "Case type:")
    expect(rendered).to have_css(".app-c-important-metadata dd", text: "Mergers")
    expect(rendered).to have_css(".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?case_type%5B%5D=mergers']",
                                 text: "Mergers")
    expect(rendered).to have_css(".app-c-important-metadata dt", text: "Case state:")
    expect(rendered).to have_css(".app-c-important-metadata dd", text: "Open")
    expect(rendered).to have_css(".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?case_state%5B%5D=open']",
                                 text: "Open")
    expect(rendered).to have_css(".app-c-important-metadata dt", text: "Market sector:")
    expect(rendered).to have_css(".app-c-important-metadata dd", text: "Motor industry")
    expect(rendered).to have_css(".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?market_sector%5B%5D=motor-industry']",
                                 text: "Motor industry")
    expect(rendered).to have_css(".app-c-important-metadata dt", text: "Outcome:")
    expect(rendered).to have_css(".app-c-important-metadata dd", text: "Mergers - phase 2 clearance with remedies")
    expect(rendered).to have_css(".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?outcome_type%5B%5D=mergers-phase-2-clearance-with-remedies']",
                                 text: "Mergers - phase 2 clearance with remedies")
  end
end
