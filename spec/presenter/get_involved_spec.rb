RSpec.describe GetInvolved do
  let(:consultation_closing_november) do
    {
      "public_timestamp" => "2024-09-20T10:51:08.000+00:00",
      "end_date" => "2024-11-28T23:59:00.000+00:00",
      "title" => "Consultation on the International Council for Harmonisation (ICH) M14",
      "link" => "/government/consultations/consultation-on-the-international-council-for-harmonisation-ich-m14",
      "_id" => "/government/consultations/consultation-on-the-international-council-for-harmonisation-ich-m14",
      "document_type" => "edition",
      "organisations" => [{ "acronym" => "DfT", "title" => "Department for Transport" }],
    }
  end

  let(:consultation_closing_december) do
    {
      "public_timestamp" => "2024-10-20T10:51:08.000+00:00",
      "end_date" => "2024-12-28T23:59:00.000+00:00",
      "title" => "Consultation on the International Council",
      "link" => "/government/consultations/consultation-on-the-international-council",
      "_id" => "/government/consultations/consultation-on-the-international-council",
      "document_type" => "edition",
      "organisations" => [{ "acronym" => "Natural England", "title" => "Natural England" }],
    }
  end

  ## Tests

  describe "#recently_opened" do
    let(:content_item) do
      instance_double(described_class, recently_opened_consultations: [consultation_closing_november, consultation_closing_december])
    end

    it "returns formatted recently opened consultation links" do
      presenter_instance = GetInvolvedPresenter.new(content_item)
      expected_output = [
        {
          link: {
            description: "Closes: 28 November 2024",
            path: consultation_closing_november["link"],
            text: consultation_closing_november["title"],
          },
          subtext: "Updated: 20 September 2024 (DfT)",
        },
        {
          link: {
            description: "Closes: 28 December 2024",
            path: consultation_closing_december["link"],
            text: consultation_closing_december["title"],
          },
          subtext: "Updated: 20 October 2024 (Natural England)",
        },
      ]

      expect(presenter_instance.recently_opened).to eq(expected_output)
    end
  end

  context "when the consultation is closed" do
    let(:content_item) do
      instance_double(described_class, next_closing_consultation: { "end_date" => (Time.zone.now.to_date - 1).strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns closed message" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("Closed")
    end
  end

  context "when the consultation is closing today" do
    let(:content_item) do
      instance_double(described_class, next_closing_consultation: { "end_date" => Time.zone.now.to_date.strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns closing today message" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("Closing today")
    end
  end

  context "when the consultation is closing tomorrow" do
    let(:content_item) do
      instance_double(described_class, next_closing_consultation: { "end_date" => (Time.zone.now.to_date + 1).strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns closing tomorrow message" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("Closing tomorrow")
    end
  end

  context "when the consultation is closing in more than 1 day" do
    let(:content_item) do
      instance_double(described_class, next_closing_consultation: { "end_date" => (Time.zone.now.to_date + 2).strftime("%Y-%m-%dT23:59:00") })
    end

    it "returns number of days left for closing" do
      presenter_instance = GetInvolvedPresenter.new(content_item)

      expect(presenter_instance.time_until_next_closure).to eq("2 days left")
    end
  end
end
