class GovukBrowserData < FlexiblePage

private

  def default_flexible_sections
    [
      {
        type: "breadcrumbs",
        breadcrumbs:,
      },
      {
        type: "page_title",
        heading_text: "GOV.UK browser and OS analytics",
        lead_paragraph: "Collated session data from the GOV.UK website, for people who find that kind of thing interesting or informative.",
      },
      {
        type: "table",
        title: "Browsers",
        caption: "Browsers sorted by the recent month's data. Percentage data is as a proportion of all sessions for that month.",
        data: {
          head: [
            {
              text: "Month",
            },
            {
              text: "Chrome",
            },
            {
              text: "Safari",
            },
            {
              text: "Edge",
            },
          ],
          rows: [
            [{ text: "December 2025" }, { text: "42.44%" }, { text: "37.56%" }, { text: "14.84%" } ],
            [{ text: "November 2025" }, { text: "43.02%" }, { text: "36.59%" }, { text: "15.62%" } ],
            [{ text: "October 2025" }, { text: "43.63%" }, { text: "36.04%" }, { text: "15.74%" } ],
          ],
        },
      },
    ]
  end
end