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
      row_lines.map do |key, value|
        {
          label: key.to_s,
          values: value[:values],
        }
      end
    end

    def data_source_link
      data["data_source_link"]
    end

  private

    def row_lines
      csv_rows.each_with_object({}) do |row, lines|
        label = row.keys.first
        variable_name = row.values.second
        value = row.values.last
        if lines.key?(variable_name)
          lines[variable_name][:values] << value.to_i
        else
          lines[variable_name] = {
            label:,
            values: [
              value.to_i,
            ],
          }
        end
      end
    end

    def csv_rows
      rows = CSV.read(csv_file_path, headers: true).map(&:to_h)
      rows.each(&:deep_symbolize_keys!)
    end

    def csv_file_path
      @csv_file_path ||= Rails.root.join("#{STATISTICS_DATA_PATH}/#{data['csv_file']}")
    end
  end
end
