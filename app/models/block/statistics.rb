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

    def row_header
      CSV.read(csv_file_path, headers: true).headers
    end

    def rows
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
