require "csv"

module Block
  class ChartLayout < Block::Base
    attr_reader :chart_id

    CHART_DATA_PATH = "lib/data/landing_page_content_items/statistics".freeze

    def initialize(block_hash)
      super(block_hash)

      @chart_id = chart_id = data["chart_id"]
    end

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

    def csv_file_name
      data["csv_file"]
    end

    def csv_file_path
      @csv_file_path ||= Rails.root.join("#{CHART_DATA_PATH}/#{data['csv_file']}")
    end
  end
end