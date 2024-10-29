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
      rows = []

      csv_rows.each do |row|
        variable_name = row.values.second
        value = row.values.last

        existing_row = rows.find { |item| item[:label].include?(variable_name) }

        if existing_row.present?
          existing_row[:values] << value.to_i
        else
          rows << {
            label: variable_name,
            values: [value.to_i],
          }
        end
      end

      rows
    end

    def attachment
      @attachment ||= landing_page.attachments.find { |att| att.filename == data["csv_file"] }
    end

  private

    def csv_rows
      @csv_rows ||= load_csv
    end

    def load_csv
      rows = if attachment
               CSV.new(URI.parse(attachment.url).open, headers: true).map(&:to_h)
             else
               # SCAFFOLDING
               csv_file_path = Rails.root.join("#{STATISTICS_DATA_PATH}/#{data['csv_file']}")
               CSV.read(csv_file_path, headers: true).map(&:to_h)
             end
      rows.each(&:deep_symbolize_keys!)
    end
  end
end
