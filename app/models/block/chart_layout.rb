require "csv"

module Block
  class ChartLayout < Block::Base
    attr_reader :chart_id

    CHART_DATA_PATH = "lib/data/landing_page_content_items/chart_data".freeze

    def initialize(block_hash)
      super(block_hash)

      @chart_id = chart_id = data["chart_id"]
    end

    def title
      content["title"]
    end

    def x_axis_label
      content["x_axis_label"]
    end

    def y_axis_label
      content["y_axis_label"]
    end

    def rows
      File.open(csv_data_path) do |file|
        CSV.read(file)
      end
    end

  private

    def content
      @content ||= begin
        filename = Rails.root.join("#{CHART_DATA_PATH}/#{chart_id}.yaml")

        return unless File.exist?(filename)

        YAML.load_file(filename)
      end
    end

    def csv_data_path
      @csv_data_path ||= Rails.root.join("#{CHART_DATA_PATH}/csvs/#{chart_id}.csv")
    end
  end
end