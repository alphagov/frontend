require "csv"
require "open-uri"

module LandingPage::Block
  class Statistics < Base
    # SCAFFOLDING
    STATISTICS_DATA_PATH = "lib/data/landing_page_content_items/statistics".freeze

    def x_axis_keys
      @x_axis_keys ||= begin
        return [] unless csv_data?

        csv_rows.map { |row| row[row.keys.first] }.uniq
      end
    end

    def rows
      return [] unless csv_data?

      csv_headers[1..].map do |header|
        values = csv_rows.map do |row|
          row[header].to_f if row[header].present?
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

    def csv_data?
      return true if opened_csv.present?

      false
    end

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
      # TODO: asset_id is a 24 char hexadecimal number which doesn't appear elsewhere in the attachment hash.
      #       We should get Whitehall to provide it rather than parsing the URL.
      match = attachment.url.match(%r{/media/(?<asset_id>[[:xdigit:]]{24})/(?<filename>[^/]+[.]csv)\z})
      raise "Unexpected URL format #{attachment.url} - cannot load CSV" unless match

      asset_id, filename = match.values_at(:asset_id, :filename)
      body = GdsApi.asset_manager.media(asset_id, filename).body
      CSV.parse(body, headers: true)
    end

    def csv_from_file
      csv_file_path = Rails.root.join("#{STATISTICS_DATA_PATH}/#{data['csv_file']}")
      return unless File.exist?(csv_file_path)

      CSV.read(csv_file_path, headers: true)
    end
  end
end
