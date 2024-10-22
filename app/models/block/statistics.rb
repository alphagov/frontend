require "csv"

module Block
  class Statistics < Block::Base
    STATISTICS_DATA_PATH = "lib/data/landing_page_content_items/statistics".freeze

    def x_axis_keys
      @x_axis_keys ||= csv_rows.map { |row| row[row.keys.first] }.uniq
    end

  private

    def csv_rows
      CSV.read(csv_file_path, headers: true).map(&:to_h)
    end

    def csv_file_path
      @csv_file_path ||= Rails.root.join("#{STATISTICS_DATA_PATH}/#{data['csv_file']}")
    end
  end
end
