RSpec.describe ConsultationPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }
  let(:content_item) { Consultation.new(content_store_response) }

  describe "#on_or_at" do
    it "returns 'on' if the opening time is 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T00:00:00+00:00"

      expect(presenter.on_or_at).to eq("on")
    end

    it "returns 'at' if the opening time is not 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-04-16T13:01:57.000+00:00"

      expect(presenter.on_or_at).to eq("at")
    end
  end

  describe "#opens_closes_or_ran" do
    context "when document type is closed_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "closed_consultation") }

      it "returns ran_from text" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation ran from")
      end
    end

    context "when document type is consultation_outcome" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome") }

      it "returns ran_from text" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation ran from")
      end
    end

    context "when document type is open_consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }

      it "returns closes_at text if document type is open_consultation" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation closes at")
      end
    end

    context "when document type is consultation" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "unopened_consultation") }

      it "returns opens at text if document type is consultation" do
        expect(presenter.opens_closes_or_ran).to eq("This consultation opens at")
      end
    end
  end

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
