require "csv"

module Block
  class Statistics < Block::Base
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

  private

    def csv_rows
      rows = CSV.read(csv_file_path, headers: true).map(&:to_h)
      rows.each(&:deep_symbolize_keys!)
    end

    def csv_file_path
      @csv_file_path ||= Rails.root.join("#{STATISTICS_DATA_PATH}/#{data['csv_file']}")
    end
  end
end
