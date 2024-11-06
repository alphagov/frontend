require "csv"
require "open-uri"

module LandingPage::Block
  class Statistics < Base
    # SCAFFOLDING
    STATISTICS_DATA_PATH = "lib/data/landing_page_content_items/statistics".freeze

    def x_axis_keys
      @x_axis_keys ||= csv_rows.map { |row| row[row.keys.first] }.uniq
    end

    def rows
      csv_headers[1..].map do |header|
        values = csv_rows.map do |row|
          row[header].to_f
        end

        {
          label: header,
          values:,
        }
      end
    end

    def attachment
      @attachment ||= landing_page.attachments.find { |att| att.filename == data["csv_file"] }
    end

  private

    def csv_rows
      @csv_rows ||= opened_csv.map(&:to_h)
    end

    def csv_headers
      opened_csv.headers
    end

    def opened_csv
      @opened_csv ||= attachment ? csv_from_url : csv_from_file
    end

    def csv_from_url
      CSV.parse(URI.parse(attachment.url).open, headers: true)
    end

    def csv_from_file
      csv_file_path = Rails.root.join("#{STATISTICS_DATA_PATH}/#{data['csv_file']}")
      CSV.read(csv_file_path, headers: true)
    end
  end
end
