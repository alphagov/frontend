require "csv"

module Block
  class Statistics < Block::Base
    STATISTICS_DATA_PATH = "lib/data/landing_page_content_items/statistics".freeze

    def title
      data["title"]
    end

    def x_axis_label
      data["x_axis_label"]
    end

    def y_axis_label
      data["y_axis_label"]
    end

    def hide_legend
      data["hide_legend"]
    end

    def x_axis_keys
      @x_axis_keys ||= csv_rows.map { |row| row[row.keys.first] }.uniq
    end

    def rows
      lines = {}
      rows = []

      csv_rows.each_with_index do |row, _i|
        if lines.key?(row["variable"].to_sym)
          lines[row["variable"].to_sym][:values] << row["value"].to_i
        else
          lines[row["variable"].to_sym] = {
            label: row["Date"],
            values: [
              row["value"].to_i,
            ],
          }
        end
      end

      lines.each_key do |key|
        rows << {
          label: key.to_s,
          values: lines[key][:values],
        }
      end

      rows
    end

    def csv_rows
      CSV.read(csv_file_path, headers: true).map(&:to_h)
    end

    def data_source_link
      data["data_source_link"]
    end

  private

    def csv_file_path
      @csv_file_path ||= Rails.root.join("#{STATISTICS_DATA_PATH}/#{data['csv_file']}")
    end
  end
end
