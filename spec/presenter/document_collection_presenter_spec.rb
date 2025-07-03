RSpec.describe DocumentCollectionPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_item) { DocumentCollection.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("document_collection", example_name: "document_collection") }

  describe "#displayable_collection_groups" do
    context "with empty collection groups" do
      let(:content_store_response) do
        GovukSchemas::Example.find("document_collection", example_name: "document_collection").tap do |item|
          item["details"]["collection_groups"][0]["documents"] = []
        end
      end

      it "returns only collection groups with items" do
        expect(content_item.collection_groups.count).to eq(6)
        expect(presenter.displayable_collection_groups.count).to eq(5)
      end
    end

    context "with collection groups that only contain withdrawn documents" do
      let(:content_store_response) do
        GovukSchemas::Example.find("document_collection", example_name: "document_collection").tap do |item|
          item["links"]["documents"][3]["withdrawn"] = true
        end
      end

      it "returns only collection groups with non-withdrawn items" do
        expect(content_item.collection_groups.count).to eq(6)
        expect(presenter.displayable_collection_groups.count).to eq(5)
      end
    end
  end

  describe "#headers_for_contents_list_component" do
    context "with no headers present in the body" do
      it "returns an empty array" do
        expect(presenter.headers_for_contents_list_component).to eq([])
      end
    end

    context "with a body with h2 headers present" do
      let(:content_store_response) { GovukSchemas::Example.find("document_collection", example_name: "document_collection_with_body") }

      it "returns the h2 headers (without nested headers) in a format suitable for a Contents List component" do
        expect(presenter.headers_for_contents_list_component).to eq([
          {
            href: "#consolidated-list",
            items: [],
            text: "Consolidated list",
          },
        ])
      end
    end
  end

  describe "#show_email_signup_link?" do
    context "with no taxonomy_topic_email_override present" do
      it "returns false" do
        expect(presenter.show_email_signup_link?).to be false
      end
    end

    context "with a taxononmy_topic_email_override present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("document_collection", example_name: "document_collection").tap do |item|
          item["links"]["taxonomy_topic_email_override"] = [{
            "base_path" => "/money/paying-hmrc",
          }]
        end
      end

      it "returns true" do
        expect(presenter.show_email_signup_link?).to be true
      end

      context "but with a non-english locale" do
        before { I18n.locale = :cy }
        after { I18n.locale = :en }

        it "returns false" do
          expect(presenter.show_email_signup_link?).to be false
        end
      end
    end
  end
end
