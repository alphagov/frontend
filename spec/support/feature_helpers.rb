module FeatureHelpers
  def assert_current_url(path_with_query, options = {})
    expected = URI.parse(path_with_query)
    current = URI.parse(page.current_url)
    expect(current.path).to eq(expected.path)
    unless options[:ignore_query]
      expect(Rack::Utils.parse_query(current.query)).to eq(Rack::Utils.parse_query(current.query))
    end
  end

  def assert_page_has_content(text)
    expect(page.text).to include(text)
  end

  def assert_bank_holiday_table(attrs)
    table = page.find("caption", text: "#{attrs[:title]} #{attrs[:year]}").ancestor("table")
    if attrs[:rows]
      actual_rows = table.all("tr").map { |r| r.all("th, td").map(&:text).map(&:strip) }
      assert_equal attrs[:rows], actual_rows
      assert_match(/\d{4}-\d{2}-\d{2}/, table.first("time")[:datetime], "datetime attributes should be formatted correctly.")
    end
  end
end
