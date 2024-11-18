RSpec.describe "BannerComponent", type: :view do
  def component_name
    "banner"
  end

  it "fails to render a banner when no text is given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders a banner with text correctly" do
    render_component(title: "Summary", text: "This was published under the 2010 to 2015 Conservative government")

    expect(rendered).to_not have_css(".app-c-banner--aside")
    expect(rendered).to have_css(".app-c-banner__desc", text: "This was published under the 2010 to 2015 Conservative government")
  end

  it "renders a banner with an aria label" do
    render_component(title: "Summary", text: "Text")
    expect(rendered).to have_css("section[aria-label]")
  end

  it "renders a banner with title and text correctly" do
    render_component(title: "Summary", text: "This was published under the 2010 to 2015 Conservative government")

    expect(rendered).to_not have_css(".app-c-banner--aside")
    expect(rendered).to have_css(".app-c-banner__title", text: "Summary")
    expect(rendered).to have_css(".app-c-banner__desc", text: "This was published under the 2010 to 2015 Conservative government")
  end

  it "renders a banner with title, text and aside correctly" do
    render_component(
      title: "Summary",
      text: "This was published under the 2010 to 2015 Conservative government",
      aside: "This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017",
    )

    expect(rendered).to have_css(".app-c-banner--aside")
    expect(rendered).to have_css(".app-c-banner__title", text: "Summary")
    expect(rendered).to have_css(".app-c-banner__desc", text: "This was published under the 2010 to 2015 Conservative government")
    expect(rendered).to have_css(".app-c-banner__desc", text: "This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017")
  end

  it "renders a banner with GA4 tracking" do
    render_component(
      title: "Summary",
      text: "This was published under the 2010 to 2015 Conservative government",
      aside: "This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017",
    )

    expect(rendered).to have_css(".app-c-banner--aside[data-module=ga4-link-tracker]")
    expect(rendered).to have_css(".app-c-banner--aside[data-ga4-track-links-only]")
    expect(rendered).to have_css(".app-c-banner--aside[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"callout\"}']")
  end
end
