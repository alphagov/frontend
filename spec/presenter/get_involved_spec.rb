RSpec.describe GetInvolved do
  let(:consultation_1) do
    {
      "end_date" => "2024-11-28T23:59:00.000+00:00",
      "title" => "Consultation on the International Council for Harmonisation (ICH) M14",
      "link" => "/government/consultations/consultation-on-the-international-council-for-harmonisation-ich-m14",
      "_id" => "/government/consultations/consultation-on-the-international-council-for-harmonisation-ich-m14",
      "document_type" => "edition",
      "organisations" => [{ "acronym" => "DfT", "title" => "Department for Transport", "public_timestamp": "2024-09-31T10:51:08.000+00:00" }],
    }
  end

  let(:consultation_2) do
    {
      "end_date" => "2024-12-28T23:59:00.000+00:00",
      "title" => "Consultation on the International Council",
      "link" => "/government/consultations/consultation-on-the-international-council",
      "_id" => "/government/consultations/consultation-on-the-international-council",
      "document_type" => "edition",
      "organisations" => [{ "acronym" => "Natural England", "title" => "Natural England", "public_timestamp": "2024-10-31T10:51:08.000+00:00" }],
    }
  end

  ## Tests

  context "recently opened consultations" do
    let(:content_item) do
      double("ContentItem", recently_opened_consultations: [consultation_1, consultation_2])
    end

    it "returns formatted recently opened consultation links" do
      presenter_instance = GetInvolvedPresenter.new(content_item)
      expected_output = [
        {
          link: {
            description: "Closes 28 November 2024",
            path: consultation_1["link"],
            text: consultation_1["title"],
          },
          metadata: {
            document_type: consultation_1["organisations"].first["acronym"],
            public_updated_at: consultation_1["organisations"].first["public_timestamp"],
          },
        },
        {
          link: {
            description: "Closes 28 December 2024",
            path: consultation_2["link"],
            text: consultation_2["title"],
          },
          metadata: {
            document_type: consultation_2["organisations"].first["acronym"],
            public_updated_at: consultation_2["organisations"].first["public_timestamp"],
          },
        },
      ]

      expect(presenter_instance.recently_opened).to eq(expected_output)
    end
  end

  context "when the consultation is closed" do
    let(:content_item) do
      double("ContentItem", next_closing_consultation: { "end_date" => (Time.zone.now.to_date - 1).strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns closed message" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("Closed")
    end
  end

  context "when the consultation is closing today" do
    let(:content_item) do
      double("ContentItem", next_closing_consultation: { "end_date" => Time.zone.now.to_date.strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns closing today message" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("Closing today")
    end
  end

  context "when the consultation is closing tomorrow" do
    let(:content_item) do
      double("ContentItem", next_closing_consultation: { "end_date" => (Time.zone.now.to_date + 1).strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns closing tomorrow message" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("Closing tomorrow")
    end
  end

  context "when the consultation is closing in more than 1 day" do
    let(:content_item) do
      double("ContentItem", next_closing_consultation: { "end_date" => (Time.zone.now.to_date + 2).strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns number of days left for closing" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("2 days left")
    end
  end
end
