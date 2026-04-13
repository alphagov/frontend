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
        data: load_table_data_from("browsers-totals-percentages.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-totals-deltas.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-totals-sessions.csv"),
      },
      {
        type: "table",
        title: "Browsers by device type",
        caption: "Percentage data is as a proportion of all sessions for that month.",
        data: load_table_data_from("browsers-by-device-type-percentages.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-by-device-type-deltas.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-by-device-type-sessions.csv"),
      },
      {
        type: "table",
        title: "Mobile browsers",
        caption: "Percentage data is as a proportion of all mobile device sessions for that month.",
        data: load_table_data_from("browsers-mobile-percentages.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-mobile-deltas.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-mobile-sessions.csv"),
      },
      {
        type: "table",
        title: "Tablet browsers",
        caption: "Percentage data is as a proportion of all tablet device sessions for that month.",
        data: load_table_data_from("browsers-tablet-percentages.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-tablet-deltas.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-tablet-sessions.csv"),
      },
      {
        type: "table",
        title: "Desktop browsers",
        caption: "Percentage data is as a proportion of all desktop and laptop device sessions for that month.",
        data: load_table_data_from("browsers-desktop-percentages.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-desktop-deltas.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-desktop-sessions.csv"),
      },
      {
        type: "table",
        title: "Smart TV and games console browsers",
        caption: "Percentage data is as a proportion of all smart TV and game console device sessions for that month.",
        data: load_table_data_from("browsers-smart_tv-percentages.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-smart_tv-deltas.csv"),
      },
      {
        type: "table",
        data: load_table_data_from("browsers-smart_tv-sessions.csv"),
      },
      {
        type: "table",
        title: "Operating systems",
        caption: "Percentage data is as a proportion of all sessions for that month.",
        data: load_table_data_from("operating-systems-sessions.csv"),
      },
      {
        type: "rich_content",
        govspeak: caveats,
      },
    ]
  end

  def load_table_data_from(filename)
    table_data = {}
    csv_rows = CSV.read(Rails.root.join("lib", "data", "govuk_browser_data", filename), headers: true)
    table_data[:head] = csv_rows.headers.map { |key| { text: key } }
    table_data[:rows] = csv_rows.map do |row|
      row.map { |cell| { text: cell.second } }
    end

    table_data
  end

  def caveats
    <<~HEREDOC
      <h2>Caveats</h2>
      <ol>
        <li>Data is sourced from the main GOV.UK website, hosted at www.gov.uk. Parts of the site under different domains, such as blogs and services, collect analytics seperately and are not included in this data.</li>
        <li>This data only includes users with JavaScript available and who explicitly opted into analytics tracking.</li>
        <li>Mobile device usage is likely to appear inflated compared to other device types, as the analytics consent banner on GOV.UK is more visually intrusive on smaller screens.</li>
        <li>Browsers that automatically restrict or block analytics tracking will, by their nature, be underrepresented in data or not appear at all.</li>
        <li>Although GOV.UK draws many international visitors, it’s a UK-centric website and the majority of sessions (about 90%) originate from within the UK. The data should not be considered representative of browser usage in other countries.</li>
        <li>Month-by-month differences can be affected by public holidays and seasonal trends, and may not represent wider trends. For example, there are notably fewer sessions from Windows devices in December and the summer months, when more people are off work.</li>
        <li>This data is provided 'as is' without support or guarantees of accuracy. Percentages and monthly change values may not add up as expected due to rounding or removal of 'junk' data in some contexts.</li>
      </ol>
    HEREDOC
  end
end
