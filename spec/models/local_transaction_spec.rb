RSpec.describe LocalTransaction do
  let(:content_store_response) do
    GovukSchemas::Example.find("local_transaction", example_name: "local_transaction_with_devolved_administration_availability")
  end

  describe "#introduction" do
    it "gets the introduction from the content store response" do
      content_item = described_class.new(content_store_response)
      expect(content_item.introduction).to eq(content_store_response["details"]["introduction"])
    end
  end

  describe "#more_information" do
    it "gets more_information from the content store response" do
      content_item = described_class.new(content_store_response)
      expect(content_item.more_information).to eq(content_store_response["details"]["more_information"])
    end
  end

  describe "#need_to_know" do
    it "gets need_to_know from the content store response" do
      content_item = described_class.new(content_store_response)
      expect(content_item.need_to_know).to eq(content_store_response["details"]["need_to_know"])
    end
  end

  describe "#unavailable?" do
    it "returns true for a country when the type is unavailable" do
      content_store_response["details"]["scotland_availability"] = {
        "type" => "unavailable",
      }
      content_store_response["details"]["wales_availability"] = {
        "type" => "unavailable",
      }
      content_store_response["details"]["northern_ireland_availability"] = {
        "type" => "unavailable",
      }
      content_item = described_class.new(content_store_response)

      ["Scotland", "Northern Ireland", "Wales"].each do |country_name|
        content_item.set_country(country_name)
        expect(content_item.unavailable?).to be true
      end
    end

    it "returns false when the country name hasn't been set" do
      content_item = described_class.new(content_store_response)
      expect(content_item.unavailable?).to be false
    end
  end

  describe "#devolved_administration_service?" do
    it "returns true when a country has a type of devolved_administration_service" do
      content_store_response["details"]["scotland_availability"] = {
        "type" => "devolved_administration_service",
      }
      content_store_response["details"]["wales_availability"] = {
        "type" => "devolved_administration_service",
      }
      content_store_response["details"]["northern_ireland_availability"] = {
        "type" => "devolved_administration_service",
      }
      content_item = described_class.new(content_store_response)

      ["Scotland", "Northern Ireland", "Wales"].each do |country_name|
        content_item.set_country(country_name)
        expect(content_item.devolved_administration_service?).to be true
      end
    end

    it "returns false when the country name hasn't been set" do
      content_item = described_class.new(content_store_response)
      expect(content_item.devolved_administration_service?).to be false
    end
  end

  describe "#devolved_administration_service_alternative_url" do
    it "returns the alternative url" do
      content_store_response["details"]["scotland_availability"] = {
        "type" => "devolved_administration_service",
        "alternative_url" => "https://www.gov.scot/stray-dog",
      }

      content_item = described_class.new(content_store_response)
      content_item.set_country("Scotland")

      expect(content_item.devolved_administration_service_alternative_url)
        .to eq("https://www.gov.scot/stray-dog")
    end

    it "returns nil when the service is unavailable" do
      content_store_response["details"]["scotland_availability"] = {
        "type" => "unavailable",
      }

      content_item = described_class.new(content_store_response)
      content_item.set_country("Scotland")

      expect(content_item.devolved_administration_service_alternative_url).to be_nil
    end

    it "does not return an alternative_url for a non devolved administration" do
      content_store_response["details"]["scotland_availability"] = {}
      content_store_response["details"]["wales_availability"] = {}
      content_store_response["details"]["northern_ireland_availability"] = {}
      content_item = described_class.new(content_store_response)

      expect(content_item.devolved_administration_service_alternative_url).to be_nil
    end
  end

  describe "#slug" do
    it "returns the subject slug" do
      content_store_response = GovukSchemas::Example.find("local_transaction", example_name: "local_transaction")
      content_store_response["base_path"] = "/foo/bar"
      expect(described_class.new(content_store_response).slug).to eq("foo/bar")
    end
  end
end
