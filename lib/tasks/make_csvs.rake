desc "Makes CSVS suitable for /govuk-browser-data from files in /ga4_exports"
task make_csvs: :environment do
  data_path = Rails.root.join("ga4_exports")
  keys = %w[browsers]
  dir = Dir.new(data_path)

  keys.each do |key|
    files_for_key = dir.each.select { |filename| filename =~ /.*-#{key}.csv/ }.sort.reverse

    data = []
    header_two = []
    totals = []
    next_month = nil

    files_for_key.each do |file|
      initial_csv = CSV.read(File.join(data_path, file))
      csv_data = initial_csv.reject { it.empty? || it.first&.starts_with?("#") }
      device_categories = csv_data.shift
      header_two = csv_data.shift
      # Do some comparison here to check that the headers are valid across files?
      totals = csv_data.shift

      device_categories.shift # remove first header line
      totals.shift # remove empty cell

      month = MonthlyBrowserData.new(file, device_categories)
      month.set_totals(totals)

      csv_data.each do |row|
        browser = row.shift
        month.set_browser_session_data(browser, row)
      end

      data << month

      next_month.set_previous_month(month) if next_month
      next_month = month
    end

    uniq_browser_names = data.each_with_object([]) { |month, names| names.concat(month.browser_names) }.uniq
    data.each { |month| month.fill_browser_session_data(uniq_browser_names) }

    data.first.device_categories.each { |device_category| create_session_percentage_delta_tables(data, device_category) }
    create_device_type_csv_file(data, "sessions") { |month, device_category| month.device_category_session_data[device_category] }
    create_device_type_csv_file(data, "percentages") { |month, device_category| display_percent(month.device_category_percentage_data[device_category]) }
    create_device_type_csv_file(data, "deltas") { |month, device_category| display_delta(month.device_category_delta_data[device_category]) }
  end
end

def create_session_percentage_delta_tables(data, device_category)
  create_browser_csv_file(data, device_category, "sessions") { |month, browser| month.session_data[browser][device_category] }
  create_browser_csv_file(data, device_category, "percentages") { |month, browser| display_percent(month.percentage_data[browser][device_category]) }
  create_browser_csv_file(data, device_category, "deltas") { |month, browser| display_delta(month.percentage_delta_data[browser][device_category]) }
end

def create_browser_csv_file(data, device_category, type)
  browser_names = data.first.browser_names_sorted_by_sessions
  filename = "browsers-#{device_category.downcase.sub(' ', '_')}-#{type}.csv"

  CSV.open(Rails.root.join("lib", "data", "govuk_browser_data", filename), "w") do |csv|
    csv << %w[Month] + browser_names
    data.each do |month|
      csv << [month.display_date] + browser_names.map { |browser| yield(month, browser) }
    end
  end
end

def create_device_type_csv_file(data, type)
  device_categories = data.first.device_categories - ["Totals"]
  filename = "browsers-by-device-type-#{type}.csv"

  CSV.open(Rails.root.join("lib", "data", "govuk_browser_data", filename), "w") do |csv|
    csv << %w[Month] + device_categories.map { DEVICE_DISPLAY_NAMES[it] }
    data.each do |month|
      csv << [month.display_date] + device_categories.map { |device_category| yield(month, device_category) }
    end
  end
end

DEVICE_DISPLAY_NAMES = {
  "mobile" => "Mobile",
  "desktop" => "Desktop",
  "tablet" => "Tablet",
  "smart tv" => "Smart TV and games consoles",
}

def display_percent(percent)
  "#{percent.round(2)}%"
end

def display_delta(delta)
  return "-" if delta.nil?
  return "0.00%" if delta.round(2).zero?
  return "+#{delta.round(2)}%" if delta.round(2).positive?

  "#{delta.round(2)}%"
end

class MonthlyBrowserData
  attr_reader :data, :date, :device_categories, :previous_month, :session_data, :totals

  def initialize(filename, device_categories)
    @data = {}
    @date = Date.parse(filename.split("-")[0..1].join("/"))
    @device_categories = device_categories
    @previous_month = nil
    @session_data = {}
    @totals = {}
  end

  def display_date
    date.strftime("%B %Y")
  end

  def set_previous_month(previous_month)
    @previous_month = previous_month
  end

  def set_totals(totals)
    @totals = device_categories.map.with_index { |category, i| [category, totals[i].to_i] }.to_h
  end

  def set_browser_session_data(browser, session_data)
    @session_data[browser] = device_categories.map.with_index { |category, i| [category, session_data[i].to_i] }.to_h
  end

  def fill_browser_session_data(browser_names)
    browser_names.each do |browser|
      next if @session_data[browser]

      @session_data[browser] = device_categories.map.with_index { |category, i| [category, 0] }.to_h
    end
  end

  def browser_names
    @session_data.keys
  end

  def browser_names_sorted_by_sessions
    browser_names.sort_by { |browser| @session_data[browser]["Totals"] }.reverse
  end

  def device_category_session_data
    device_categories.map do |device_category|
      [device_category, totals[device_category]]
    end.to_h
  end

  def device_category_percentage_data
    device_categories.map do |device_category|
      [device_category, (100.0 / @totals["Totals"]) * totals[device_category]]
    end.to_h
  end

  def device_category_delta_data
    pm_data = previous_month&.device_category_percentage_data

    device_category_percentage_data.map do |device_category, value|
      delta = if pm_data
        value - (pm_data[device_category] ? pm_data[device_category] : 0.0)
      end
      [device_category, delta]
    end.to_h
  end

  def percentage_data
    @session_data.map { |browser, data|
      percentages = data.map { |device_category, value|
        [device_category, (100.0 / @totals[device_category]) * value]
      }.to_h
      [browser, percentages]
    }.to_h
  end

  def percentage_delta_data
    pm_data = previous_month&.percentage_data

    percentage_data.map { |browser, data|
      percentage_delta = data.map { |device_category, value|
        delta = if pm_data
                  value - (pm_data[browser] ? pm_data[browser][device_category] : 0.0)
                end
        [device_category, delta]
      }.to_h
      [browser, percentage_delta]
    }.to_h
  end
end
