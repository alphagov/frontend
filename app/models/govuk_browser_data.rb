class GovukBrowserData < ContentItem
  TABLE_TABS = {
    percentages: "Share",
    deltas: "Change",
    sessions: "Sessions",
  }.freeze

  def tables
    [
      {
        title: "Browsers",
        caption: "Browsers sorted by the recent month's data. Percentage data is as a proportion of all sessions for that month.",
        filename_base: "browsers-totals",
      },
      {
        title: "Browsers by device type",
        caption: "Percentage data is as a proportion of all sessions for that month.",
        filename_base: "browsers-by-device-type",
      },
      {
        title: "Mobile browsers",
        caption: "Percentage data is as a proportion of all mobile device sessions for that month.",
        filename_base: "browsers-mobile",
      },
      {
        title: "Tablet browsers",
        caption: "Percentage data is as a proportion of all tablet device sessions for that month.",
        filename_base: "browsers-tablet",
      },
      {
        title: "Desktop browsers",
        caption: "Percentage data is as a proportion of all desktop and laptop device sessions for that month.",
        filename_base: "browsers-desktop",
      },
      {
        title: "Smart TV and games console browsers",
        caption: "Percentage data is as a proportion of all smart TV and game console device sessions for that month.",
        filename_base: "browsers-smart_tv",
      },
      {
        title: "Operating systems",
        caption: "Percentage data is as a proportion of all sessions for that month.",
        filename_base: "operating-systems",
      },
      {
        title: "Most used browser and OS combinations",
        caption: "The 20 most popular browser/OS combinations as of the most recent month's data. Percentage data is as a percentage of all sessions for that month.",
        filename_base: "browser-os-combos",
      },
    ]
  end

  def table_data_from(filename)
    table_data = {}
    csv_rows = CSV.read(Rails.root.join("lib", "data", "govuk_browser_data", filename), headers: true)
    table_data[:head] = csv_rows.headers.map { |key| { text: key } }
    table_data[:rows] = csv_rows.map do |row|
      row.map { |cell| { text: cell.second } }
    end

    table_data
  end
end
