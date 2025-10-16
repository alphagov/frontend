RSpec.describe ConsultationPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }
  let(:content_item) { Consultation.new(content_store_response) }

  describe "#notice_title" do
    context "when document type is open_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }

      it "returns empty text" do
        expect(presenter.notice_title).to eq("")
      end
    end

    context "when document type is unopened_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "unopened_consultation") }

      it "returns not_open_yet text" do
        expect(presenter.notice_title).to eq("This consultation isn't open yet")
      end
    end

    context "when document type is closed_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "closed_consultation") }

      it "returns analysing_feedback text" do
        expect(presenter.notice_title).to eq("We are analysing your feedback")
      end
    end

    context "when document type is consultation_outcome" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome") }

      it "returns concluded text" do
        expect(presenter.notice_title).to eq("This consultation has concluded")
      end
    end
  end

  describe "#notice_description" do
    context "when document type is open_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }

      it "returns empty text" do
        expect(presenter.notice_description).to eq("")
      end
    end

    context "when document type is unopened_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "unopened_consultation") }

      it "returns not_open_yet text" do
        expect(presenter.notice_description).to eq("This consultation opens")
      end
    end

    context "when document type is closed_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "closed_consultation") }

      it "returns visit_soon text" do
        expect(presenter.notice_description).to eq("Visit this page again soon to download the outcome to this public feedback.")
      end
    end

    context "when document type is consultation_outcome" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome") }

      it "returns empty text" do
        expect(presenter.notice_description).to eq("")
      end
    end
  end
end
