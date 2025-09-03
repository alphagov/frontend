RSpec.shared_examples "it can have a contents list" do |document_type, example_name|
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  context "when there are no headers present in the body" do
    before do
      content_store_response["details"]["headers"] = nil
    end

    it "returns an empty array" do
      expect(presenter.headers_for_contents_list_component).to eq([])
    end
  end

  context "when there are h2s headers present in the body" do
    it "returns the h2 headers in a format suitable for a Contents List component" do
      expected_headers = content_item.headers

      expect(presenter.headers_for_contents_list_component.count).to eq(expected_headers.count)

      expect(presenter.headers_for_contents_list_component[0][:href]).to include(expected_headers[0]["id"])
      expect(presenter.headers_for_contents_list_component[0][:text]).to eq(expected_headers[0]["text"])
    end

    it "strips the nested headers from the headers for the contents list" do
      expect(presenter.headers_for_contents_list_component[0][:items]).to be_empty
    end
  end
end
