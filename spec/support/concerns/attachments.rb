RSpec.shared_examples "it can have attachments" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:expected_attachments) { content_store_response["details"]["attachments"] }

  it "knows it has attachments" do
    expect(expected_attachments).to be_present

    expect(described_class.new(content_store_response).attachments).to eq(expected_attachments)
  end

  it "returns an empty array if there are no attachments" do
    content_store_response["details"].delete("attachments")
    expect(described_class.new(content_store_response).attachments).to eq([])
  end

  it "returns a sublist of featured attachments based on list of IDs" do
    attachment_id_list = content_store_response["details"]["featured_attachments"]
    expected_featured_attachments = expected_attachments.select { |doc| (attachment_id_list || []).include? doc["id"] }

    expect(described_class.new(content_store_response).featured_attachments).to be_present
    expect(described_class.new(content_store_response).featured_attachments).to eq(expected_featured_attachments)
  end

  context "when checking attachment properties" do
    let(:attachment) { content_store_response["details"]["attachments"].first }

    it "sets the attachment type as 'html' by default" do
      attachment.delete("content_type")

      expect(described_class.new(content_store_response).attachments.first["type"]).to eq("html")
    end

    it "sets the attachment type as 'external' if it's an external attachment" do
      attachment["attachment_type"] = "external"

      expect(described_class.new(content_store_response).attachments.first["type"]).to eq("external")
    end

    it "updates the preview_url based on url if content_type is text/csv" do
      attachment["content_type"] = "text/csv"
      expected_preview_url = "#{attachment['url']}/preview"

      expect(described_class.new(content_store_response).attachments.first["preview_url"]).to eq(expected_preview_url)
    end

    it "updates the preview_url based on asset_manager_id and matching filename" do
      content_store_response["details"]["attachments"].first["filename"] = "some-file.pdf"
      attachment["assets"] = [{ "asset_manager_id" => "some-attachment-data-id", "filename" => "some-file.pdf" }]
      attachment["content_type"] = "text/csv"

      expected_preview_url = "/csv-preview/some-attachment-data-id/some-file.pdf"
      expect(described_class.new(content_store_response).attachments.first["preview_url"]).to eq(expected_preview_url)
    end

    it "does not update the preview_url if the filename does not match" do
      content_store_response["details"]["attachments"].first["filename"] = "some-other-file.pdf"
      attachment["assets"] = [{ "asset_manager_id" => "some-attachment-data-id", "filename" => "some-filename" }]
      attachment["content_type"] = "text/csv"

      expect(described_class.new(content_store_response).attachments.first["preview_url"]).to be_nil
    end

    it "sets the alternative_format_contact_email to be nil if it's accessible" do
      attachment["accessible"] = true

      expect(described_class.new(content_store_response).attachments.first["alternative_format_contact_email"]).to be_nil
    end
  end
end
