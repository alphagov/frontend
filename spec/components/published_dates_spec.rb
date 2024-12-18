RSpec.describe "PublishedDates", type: :view do
  def component_name
    "published_dates"
  end

  it "renders nothing when no dates are provided" do
    render_component({})
    expect(rendered).to be_empty
  end

  it "renders published date" do
    render_component(published: "1st November 2000")
    expect(rendered).to have_css(".app-c-published-dates", text: "Published 1st November 2000")
  end

  it "renders published date and last updated date" do
    render_component(published: "1st November 2000", last_updated: "15th July 2015")
    assert_select ".app-c-published-dates", text: "Updates to this page
      Published 1st November 2000
      Last updated 15th July 2015"
  end

  it "links to full page history" do
    render_component(published: "1st November 2000", last_updated: "15th July 2015", link_to_history: true)
    expect(rendered).to have_css(".app-c-published-dates a[href=\"#history\"]")
  end

  it "renders full page history" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"],
    )
    expect(rendered).to have_css(".app-c-published-dates__change-history#full-history")
    expect(rendered).to have_css(".app-c-published-dates--history .app-c-published-dates__change-date", text: "23 August 2013")
  end

  it "strips leading and trailing whitespace from note text" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"],
    )
    expect(rendered).to have_css(".app-c-published-dates__change-history#full-history")
    expect(rendered).to have_css(".app-c-published-dates--history .app-c-published-dates__change-note", text: /^\S/)
  end

  it "only adds history id when passed page history" do
    render_component(published: "1st November 2000")
    expect(rendered).not_to have_css("#full-publication-update-history", visible: false)

    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"],
    )
    expect(rendered).to have_css("#full-publication-update-history")
  end

  it "full page history is hidden on page load" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"],
    )
    expect(rendered).to have_css(".app-c-published-dates__change-history.js-hidden")
  end

  it "renders link to full page history if history is provided" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"],
    )
    expect(rendered).to have_css(".app-c-published-dates a[href=\"#full-history\"]")
  end

  it "includes data attributes for toggle behaviour" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"],
    )

    expect(rendered).to have_css(".app-c-published-dates--history[data-module='gem-toggle']")
    expect(rendered).to have_css(".app-c-published-dates--history a[href='#full-history'][data-controls='full-history']")
    expect(rendered).to have_css(".app-c-published-dates--history a[href='#full-history'][data-expanded='false']")
  end

  it "applies a custom margin-bottom class if margin_bottom is specified" do
    render_component(published: "1st November 2000", margin_bottom: 5)
    expect(rendered).to have_css('.app-c-published-dates.govuk-\!-margin-bottom-5')
  end

  it "accordion has GA4 tracking" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"],
    )

    expected_ga4_json = {
      "event_name": "select_content",
      "type": "content history",
      "section": "Footer",
    }.to_json

    expect(rendered).to have_css("a[data-module='ga4-event-tracker']")
    expect(rendered).to have_css("a[data-ga4-expandable='']")
    expect(rendered).to have_css("a[data-ga4-event='#{expected_ga4_json}']")
  end
end
