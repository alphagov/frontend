RSpec.describe ConsultationPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }
  let(:content_item) { Consultation.new(content_store_response) }

  describe "#opening_date" do
    it "presents a friendly opening date and time" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T10:00:00+00:00"

      expect(presenter.opening_date).to eq("10am on 4 November 2016")
    end

    it "presents an opening date without a time if the time is 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-03T00:00:00+00:00"

      expect(presenter.opening_date).to eq("3 November 2016")
    end

    it "presents 12pm as midday" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T12:00:00+00:00"

      expect(presenter.opening_date).to eq("midday on 4 November 2016")
    end
  end
end
