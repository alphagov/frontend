RSpec.describe Transaction do
  let(:content_store_response) { GovukSchemas::Example.find("transaction", example_name: "transaction") }

  before do
    content_store_response["details"] = {
      "introductory_paragraph" => "foo",
      "more_information" => "bar",
      "other_ways_to_apply" => "carrots",
      "transaction_start_link" => "bananas",
      "what_you_need_to_know" => "hats",
      "will_continue_on" => "scarves",
      "start_button_text" => "Start now",
      "department_analytics_profile" => "UA-12345-6",
      "downtime_message" => "This service will be unavailable.",
    }
  end

  describe "#department_analytics_profile" do
    it "gets department_analytics_profile from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.department_analytics_profile).to eq("UA-12345-6")
    end

    context "when there are variants" do
      it "gets department_analytics_profile from the variant" do
        variants = [
          {
            "title" => "Check your Council Tax band (staging)",
            "slug" => "council-tax-bands-2-staging",
            "department_analytics_profile" => "UA-13579-8",
          },
        ]

        content_store_response["details"]["variants"] = variants
        content_item = described_class.new(content_store_response)
        content_item.set_variant("council-tax-bands-2-staging")

        expect(content_item.department_analytics_profile).to eq("UA-13579-8")
      end
    end
  end

  describe "#downtime_message" do
    it "gets downtime_message from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.downtime_message).to eq("This service will be unavailable.")
    end
  end

  describe "#introductory_paragraph" do
    it "gets introductory_paragraph from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.introductory_paragraph).to eq("foo")
    end
  end

  describe "#more_information" do
    it "gets more_information from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.more_information).to eq("bar")
    end
  end

  describe "#other_ways_to_apply" do
    it "gets other_ways_to_apply from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.other_ways_to_apply).to eq("carrots")
    end
  end

  describe "#title" do
    it "gets the content item title" do
      content_item = described_class.new(content_store_response)

      expect(content_item.title).to eq(content_store_response["title"])
    end
  end

  describe "#transaction_start_link" do
    it "gets transaction_start_link from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.transaction_start_link).to eq("bananas")
    end
  end

  describe "#what_you_need_to_know" do
    it "gets what_you_need_to_know from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.what_you_need_to_know).to eq("hats")
    end
  end

  describe "#will_continue_on" do
    it "gets will_continue_on from details" do
      content_item = described_class.new(content_store_response)

      expect(content_item.will_continue_on).to eq("scarves")
    end
  end
end
