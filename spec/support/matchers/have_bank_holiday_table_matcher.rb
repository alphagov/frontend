RSpec::Matchers.define :have_bank_holiday_table do |attrs = {}|
  failure_message { "'#{page}' has the wrong rows or has incorrectly formatted datetime attributes" }

  match do |page|
    table = page.find("caption", text: "#{attrs[:title]} #{attrs[:year]}").ancestor("table")
    if attrs[:rows]
      actual_rows = table.all("tr").map { |r| r.all("th, td").map(&:text).map(&:strip) }
      expect(attrs[:rows]).to eq(actual_rows)
      expect(table.first("time")[:datetime]).to match(/\d{4}-\d{2}-\d{2}/)
    end
  end
end
