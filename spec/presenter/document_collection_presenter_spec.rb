RSpec.describe DocumentCollectionPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_item) { DocumentCollection.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("document_collection", example_name: "document_collection") }

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
