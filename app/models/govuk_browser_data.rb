class GovukBrowserData < ContentItem
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
