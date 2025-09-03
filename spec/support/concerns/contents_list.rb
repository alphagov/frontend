RSpec.shared_examples "it can have a contents list" do |document_type, example_name|
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  let(:additional_headers) do
    [
      { "id" => "consolidated-list", "level" => 2, "text" => "Consolidated list" },
      { "id" => "further-information", "level" => 2, "text" => "Further information" },
    ]
  end

  context "when there are no headers present in the body" do
    before do
      content_store_response["details"]["headers"] = nil
    end

    it "returns an empty array" do
      expect(presenter.headers_for_contents_list_component).to eq([])
    end

    context "when there are additional headers" do
      it "includes the h2 headers" do
        headers = presenter.headers_for_contents_list_component(additional_headers:)

        expect(headers.count).to eq(2)
        expect(headers[0][:href]).to include(additional_headers[0]["id"])
        expect(headers[0][:text]).to eq(additional_headers[0]["text"])
      end
    end
  end

  context "when there are h2s headers present in the body" do
    it "includes the content_item headers" do
      expected_headers = content_item.headers

      expect(presenter.headers_for_contents_list_component.count).to be > 0

      expect(presenter.headers_for_contents_list_component.count).to eq(expected_headers.count)
    end

    it "returns the h2 headers in a format suitable for a Contents List component" do
      expected_headers = content_item.headers

      expect(presenter.headers_for_contents_list_component[0][:href]).to include(expected_headers[0]["id"])
      expect(presenter.headers_for_contents_list_component[0][:text]).to eq(expected_headers[0]["text"])
    end

    context "when there are nested headers" do
      before do
        content_store_response["details"]["headers"] = [
          {
            "text" => "Summary",
            "level" => 2,
            "id" => "summary",
            "headers" => [
              { "text" => "Download report", "level" => 3, "id" => "download-report" },
              { "text" => "Download glossary", "level" => 3, "id" => "download-glossary" },
            ],
          },
        ]
      end

      it "by default strips the nested headers from the headers for the contents list" do
        expect(presenter.headers_for_contents_list_component[0][:items]).to be_empty
      end
    end

    context "when there are additional headers" do
      it "includes the h2 headers" do
        expected_headers_count = content_item.headers.count + additional_headers.count

        headers = presenter.headers_for_contents_list_component(additional_headers:)

        expect(headers.count).to eq(expected_headers_count)
        expect(headers.last[:href]).to include(additional_headers.last["id"])
        expect(headers.last[:text]).to eq(additional_headers.last["text"])
      end
    end
  end
end
