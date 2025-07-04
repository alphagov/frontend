module Attachments
  extend ActiveSupport::Concern

  included do
    def attachments
      return [] unless content_item_attachments

      docs = content_item_attachments.select { |a| !a.key?("locale") || a["locale"] == locale }

      docs.each do |doc|
        doc["type"] = "html" unless doc["content_type"]
        doc["type"] = "external" if doc["attachment_type"] == "external"
        doc["preview_url"] = csv_preview_url(doc) if doc["content_type"] == "text/csv"
        doc["alternative_format_contact_email"] = nil if doc["accessible"] == true
      end
    end

    def attachments_from(attachment_id_list)
      attachments.select { |doc| (attachment_id_list || []).include? doc["id"] }
    end
  end

private

  def csv_preview_url(doc)
    asset = doc["assets"]&.first
    if asset.nil?
      # This is a temporary edge case whilst assets are a new field on all csv attachments.
      Rails.logger.warn("Assets key is missing from attachment at #{doc['url']}")
      "#{doc['url']}/preview"
    elsif asset["filename"] == doc["filename"]
      "/csv-preview/#{asset['asset_manager_id']}/#{asset['filename']}"
    end
  end

  def content_item_attachments
    @content_item_attachments ||= content_store_response.dig("details", "attachments")
  end
end
