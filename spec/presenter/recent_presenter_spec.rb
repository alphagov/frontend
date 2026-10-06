RSpec.describe RecentPresenter do
  subject(:result_presenter) { described_class.new(results) }

  describe "#formatted_results" do
    let(:results) do
      [{
        link: {
          text: "Supergirl joins Justice League",
          path: "/news/supergirl-justice",
        },
        metadata: {
          public_updated_at: "2025-12-01T00:00:01Z",
          document_type: "News",
          display_type: "news",
          description: "Supergirl joins the Justice League as the newest member of the team.",
        },
      }]
    end

    it "returns the expected format" do
      expected_results = [{
        link: {
          text: "Supergirl joins Justice League",
          path: "/news/supergirl-justice",
          description: "Supergirl joins the Justice League as the newest member of the team.",
        },
        metadata: {
          public_updated_at: "2025-12-01T00:00:01Z",
          document_type: "News",
        },
      }]

      expect(result_presenter.formatted_results).to eq(expected_results)
    end
  end
end
