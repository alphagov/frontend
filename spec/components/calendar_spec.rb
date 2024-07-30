RSpec.describe "CalendarComponent", type: :view do
  def component_name
    "calendar"
  end

  it "renders the basic component" do
    render_component({})

    expect(rendered).to have_css(".app-c-calendar")
  end

  it "renders the component with correct data passed" do
    render_component(
      title: "Marvel films",
      year: "2008 onwards",
      headings: [
        { text: "Date" },
        { text: "Day of the week" },
        { text: "Film" },
      ],
      events: [
        {
          title: "Iron Man",
          date: Date.parse("2-5-2008"),
          notes: "first film in the MCU",
        },
        {
          title: "The Incredible Hulk",
          date: Date.parse("13-6-2008"),
          notes: "",
        },
      ],
    )

    expect(rendered).to have_css(".govuk-table__caption .govuk-visually-hidden", text: "Marvel films")
    expect(rendered).to have_css(".govuk-table__caption", text: "Marvel films 2008 onwards")
    expect(rendered).to have_css(".govuk-table__head .govuk-table__header:nth-child(1)", text: "Date")
    expect(rendered).to have_css(".govuk-table__head .govuk-table__header:nth-child(2)", text: "Day of the week")
    expect(rendered).to have_css(".govuk-table__head .govuk-table__header:nth-child(3)", text: "Film")
    expect(rendered).to have_css(".govuk-table__row:nth-child(1) .govuk-table__header", text: "2 May")
    expect(rendered).to have_css(".govuk-table__row:nth-child(1) .govuk-table__cell:nth-child(2)", text: "Friday")
    expect(rendered).to have_css(".govuk-table__row:nth-child(1) .govuk-table__cell:nth-child(3)", text: "Iron Man (first film in the mcu)")
    expect(rendered).to have_css(".govuk-table__row:nth-child(2) .govuk-table__header", text: "13 June")
    expect(rendered).to have_css(".govuk-table__row:nth-child(2) .govuk-table__cell:nth-child(2)", text: "Friday")
    expect(rendered).to have_css(".govuk-table__row:nth-child(2) .govuk-table__cell:nth-child(3)", text: "The Incredible Hulk")
  end
end
