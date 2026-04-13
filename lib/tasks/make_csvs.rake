desc "Makes CSVS suitable for /govuk-browser-data from files in /ga4_exports"
task make_csvs: :environment do
  data_path = Rails.root.join("ga4_exports")
  keys = %w[browsers]
  dir = Dir.new(data_path)

  keys.each do |key|
    files_for_key = dir.each.select { |filename| filename =~ /.*-#{key}.csv/ }.sort

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

    data.first.device_categories.each { |device_category| create_session_percentage_delta_tables(data, device_category) }
  end
end

def create_session_percentage_delta_tables(data, device_category)
  create_data_csv_file(data, device_category, "sessions") { |month, browser| month.session_data[browser][device_category] }
  create_data_csv_file(data, device_category, "percentages") { |month, browser| display_percent(month.percentage_data[browser][device_category]) }
  create_data_csv_file(data, device_category, "deltas") { |month, browser| display_delta(month.percentage_delta_data[browser][device_category]) }
end

def create_data_csv_file(data, device_category, type)
  browser_names = data.first.browser_names
  filename = "browsers-#{device_category.downcase.sub(' ', '_')}-#{type}.csv"

  CSV.open(Rails.root.join("lib", "data", "govuk_browser_data", filename), "w") do |csv|
    csv << %w[Month] + browser_names
    data.each do |month|
      csv << [month.display_date] + browser_names.map { |browser| yield(month, browser) }
    end
  end
end

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

  def browser_names
    @session_data.keys
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
