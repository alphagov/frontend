require "gds_api/test_helpers/search"

RSpec.describe LandingPage::Block::DocumentList do
  include GdsApi::TestHelpers::Search
  include ContentStoreHelpers

  describe "#items" do
    context "when the list is hard-coded" do
      let(:blocks_hash) do
        { "type" => "document_list",
          "items" => [
            { "text" => "link 1", "path" => "/a-link", "document_type" => "News article", "public_updated_at" => "2024-01-01 10:24:00" },
            { "text" => "link 2", "path" => "/another-link", "document_type" => "Press release", "public_updated_at" => "2023-01-01 10:24:00" },
          ] }
      end

      it "returns an array of link details" do
        result = described_class.new(blocks_hash, build(:landing_page)).items
        expect(result.size).to eq 2
        expect(result.first).to eq(link: { text: "link 1", path: "/a-link" }, metadata: { document_type: "News article", public_updated_at: "2024-01-01 10:24:00" })
        expect(result.second).to eq(link: { text: "link 2", path: "/another-link" }, metadata: { document_type: "Press release", public_updated_at: "2023-01-01 10:24:00" })
      end
    end

    context "when a taxon path is provided" do
      let(:blocks_hash) do
        { "type" => "document_list",
          "taxon_base_path" => basic_taxon["base_path"] }
      end

      it "returns an array of items tagged to the taxon" do
        stub_content_store_has_item(basic_taxon["base_path"], basic_taxon)
        stub_taxon_search_results

        expected_result = {
          link: {
            text: "Doc one",
            path: "/doc-one",
          },
          metadata: {
            document_type: "Press release",
            public_updated_at: "2024-01-01 10:24:00",
          },
        }

        result = described_class.new(blocks_hash, build(:landing_page)).items
        expect(result.size).to eq 1
        expect(result.first).to eq(expected_result)
      end
    end

    context "when both the taxon base path and a hard-coded list is provided" do
      let(:blocks_hash) do
        { "type" => "document_list",
          "taxon_base_path" => basic_taxon["base_path"],
          "items" => [
            { "text" => "link 1", "path" => "/a-link", "document_type" => "News article", "public_updated_at" => "2024-01-01 10:24:00" },
            { "text" => "link 2", "path" => "/another-link", "document_type" => "Press release", "public_updated_at" => "2023-01-01 10:24:00" },
          ] }
      end

      it "only returns an array of items tagged to the taxon" do
        stub_content_store_has_item(basic_taxon["base_path"], basic_taxon)
        stub_taxon_search_results

        expected_result = {
          link: {
            text: "Doc one",
            path: "/doc-one",
          },
          metadata: {
            document_type: "Press release",
            public_updated_at: "2024-01-01 10:24:00",
          },
        }

        result = described_class.new(blocks_hash, build(:landing_page)).items
        expect(result.size).to eq 1
        expect(result.first).to eq(expected_result)
      end

      it "returns the hard-coded list if the taxon doesn't exist" do
        stub_content_store_does_not_have_item(basic_taxon["base_path"])

        expected_first_result = {
          link: {
            text: "link 1",
            path: "/a-link",
          },
          metadata: {
            document_type: "News article",
            public_updated_at: "2024-01-01 10:24:00",
          },
        }

        result = described_class.new(blocks_hash, build(:landing_page)).items
        expect(result.size).to eq 2
        expect(result.first).to eq(expected_first_result)
      end

      it "returns the hard-coded list if nothing is tagged to the taxon" do
        stub_content_store_has_item(basic_taxon["base_path"], basic_taxon)
        stub_any_search_to_return_no_results

        expected_first_result = {
          link: {
            text: "link 1",
            path: "/a-link",
          },
          metadata: {
            document_type: "News article",
            public_updated_at: "2024-01-01 10:24:00",
          },
        }

        result = described_class.new(blocks_hash, build(:landing_page)).items
        expect(result.size).to eq 2
        expect(result.first).to eq(expected_first_result)
      end
    end

    context "when there is nothing tagged to the taxon and a hard-coded list is not provided" do
      let(:blocks_hash) do
        { "type" => "document_list",
          "taxon_base_path" => basic_taxon["base_path"] }
      end

      it "returns an empty list" do
        stub_content_store_has_item(basic_taxon["base_path"], basic_taxon)
        stub_any_search_to_return_no_results

        expect(described_class.new(blocks_hash, build(:landing_page)).items).to eq([])
      end
    end
  end

  def stub_taxon_search_results
    results = [
      {
        "title" => "Doc one",
        "link" => "/doc-one",
        "description" => "Doc one description",
        "format" => "press_release",
        "public_timestamp" => Time.zone.local(2024, 1, 1, 10, 24, 0),
      },
    ]

    body = {
      "results" => results,
      "start" => "0",
      "total" => results.size,
    }

    stub_any_search.to_return("body" => body.to_json)
  end
end
