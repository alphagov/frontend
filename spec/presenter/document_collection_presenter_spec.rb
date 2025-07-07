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

  describe "#group_as_document_list" do
    let(:group) { content_item.collection_groups.first }

    it "returns an array suitable for passing to a documents_list component" do
      expected_first = {
        link: {
          text: "National standard for driving cars and light vans",
          path: "/government/publications/national-standard-for-driving-cars-and-light-vans",
        },
        metadata: {
          public_updated_at: Time.zone.parse("2007-03-16 15:00:02.000000000 +0000"),
          document_type: "Guidance",
        },
      }

      expect(presenter.group_as_document_list(group).count).to eq(3)
      expect(presenter.group_as_document_list(group).first).to eq(expected_first)
    end

    context "when a document in the group is withdrawn" do
      let(:content_store_response) do
        GovukSchemas::Example.find("document_collection", example_name: "document_collection").tap do |item|
          item["links"]["documents"][8]["withdrawn"] = true
        end
      end

      it "returns only the non-withdrawn documents" do
        expect(presenter.group_as_document_list(group).count).to eq(2)
      end
    end

    context "when a document in the group is of a type without allowed public updates" do
      let(:content_store_response) do
        GovukSchemas::Example.find("document_collection", example_name: "document_collection").tap do |item|
          item["links"]["documents"][8]["document_type"] = "simple_smart_answer"
        end
      end

      it "returns nil for public_updated_at metadata" do
        expect(presenter.group_as_document_list(group).first[:metadata][:public_updated_at]).to be_nil
      end
    end

    context "when a document in the group doesn't have a public_updated_at value" do
      let(:content_store_response) do
        GovukSchemas::Example.find("document_collection", example_name: "document_collection").tap do |item|
          item["links"]["documents"][8]["public_updated_at"] = nil
        end
      end

      it "returns nil for public_updated_at metadata" do
        expect(presenter.group_as_document_list(group).first[:metadata][:public_updated_at]).to be_nil
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
        expect(presenter.headers_for_contents_list_component.count).to eq(1)

        expect(presenter.headers_for_contents_list_component[0][:href]).to eq("#consolidated-list")
        expect(presenter.headers_for_contents_list_component[0][:text]).to eq("Consolidated list")
      end

      it "strips the nested headers from the headers for the contents list" do
        expect(presenter.headers_for_contents_list_component[0][:items]).to be_empty
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
