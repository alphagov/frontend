RSpec.describe LocalTransactionPresenter do
  def subject(content_item)
    described_class.new(content_item.deep_stringify_keys!)
  end

  describe "#introduction" do
    it "shows the introduction" do
      expect(subject(details: { introduction: "foo" }).introduction).to eq("foo")
    end
  end

  describe "#more_information" do
    it "shows the more_information" do
      expect(subject(details: { more_information: "foo" }).more_information).to eq("foo")
    end
  end

  describe "#need_to_know" do
    it "shows the need_to_know" do
      expect(subject(details: { need_to_know: "foo" }).need_to_know).to eq("foo")
    end
  end

  describe "#scotland_availability" do
    it "presents the type and alternative_url for scotland" do
      devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }

      expect(subject(devolved_administration).scotland_availability["type"]).to eq("devolved_administration_service")
      expect(subject(devolved_administration).scotland_availability["alternative_url"]).to eq("https://gov.scot")
    end
  end

  describe "#wales_availability" do
    it "presents the type and alternative_url for wales" do
      devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }

      expect(subject(devolved_administration).wales_availability["type"]).to eq("unavailable")
      expect(subject(devolved_administration).wales_availability["alternative_url"]).to be_nil
    end
  end

  describe "#northern_ireland_availability" do
    it "presents the type and alternative_url for northern ireland" do
      devolved_administration = { "details" => { "northern_ireland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://www.nidirect.gov.uk" } } }

      expect(subject(devolved_administration).northern_ireland_availability["type"]).to eq("devolved_administration_service")
      expect(subject(devolved_administration).northern_ireland_availability["alternative_url"]).to eq("https://www.nidirect.gov.uk")
    end
  end

  describe "#unavailable?" do
    it "is true for a devolved administration marked as unavailable" do
      devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }
      expect(subject(devolved_administration).unavailable?("Wales")).to be true
    end

    it "is false for a devolved administration marked as devolved_administration_service" do
      devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }
      expect(subject(devolved_administration).unavailable?("Scotland")).to be false
    end

    it "is false for a non devolved administration" do
      devolved_administration = { "details" => {} }
      expect(subject(devolved_administration).unavailable?("England")).to be false
    end
  end

  describe "#devolved_administration_service?" do
    it "is true for a devolved administration marked as devolved_administration_service" do
      devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }

      expect(subject(devolved_administration).devolved_administration_service?("Scotland")).to be true
    end

    it "is false for a devolved administration marked as unavailable" do
      devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }

      expect(subject(devolved_administration).devolved_administration_service?("Wales")).to be false
    end

    it "is false for a non devolved administration" do
      devolved_administration = { "details" => {} }

      expect(subject(devolved_administration).devolved_administration_service?("England")).to be false
    end
  end

  describe "#devolved_administration_service_alternative_url" do
    it "returns an alternative_url for a devolved_administration_service" do
      devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }

      expect(subject(devolved_administration).devolved_administration_service_alternative_url("Scotland")).to eq("https://gov.scot")
    end

    it "does not return an alternative_url for an unavailable service" do
      devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }

      expect(subject(devolved_administration).devolved_administration_service_alternative_url("Wales")).to be_nil
    end

    it "does not return an alternative_url for a non devolved administration" do
      devolved_administration = { "details" => {} }

      expect(subject(devolved_administration).devolved_administration_service_alternative_url("England")).to be_nil
    end
  end
end
