RSpec.describe LocalTransaction do
  subject(:local_transaction) { described_class.new(content_store_response) }

  let(:content_store_response) do
    GovukSchemas::Example.find("local_transaction", example_name: "local_transaction_with_devolved_administration_availability")
  end

  describe "#introduction" do
    it "gets the introduction from the content store response" do
      expect(local_transaction.introduction).to eq(content_store_response["details"]["introduction"])
    end
  end

  describe "#cta_text" do
    it "gets cta_text from the content store response" do
      expect(local_transaction.cta_text).to eq(content_store_response["details"]["cta_text"])
    end
  end

  describe "#more_information" do
    it "gets more_information from the content store response" do
      expect(local_transaction.more_information).to eq(content_store_response["details"]["more_information"])
    end
  end

  describe "#need_to_know" do
    it "gets need_to_know from the content store response" do
      expect(local_transaction.need_to_know).to eq(content_store_response["details"]["need_to_know"])
    end
  end

  describe "#before_results" do
    it "gets before results from the content store response" do
      expect(local_transaction.before_results).to eq(content_store_response["details"]["before_results"])
    end
  end

  describe "#after_results" do
    it "gets after results from the content store response" do
      expect(local_transaction.after_results).to eq(content_store_response["details"]["after_results"])
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

      ["Scotland", "Northern Ireland", "Wales"].each do |country_name|
        local_transaction.set_country(country_name)
        expect(local_transaction.unavailable?).to be true
      end
    end

    it "returns false when the country name hasn't been set" do
      expect(local_transaction.unavailable?).to be false
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

      ["Scotland", "Northern Ireland", "Wales"].each do |country_name|
        local_transaction.set_country(country_name)
        expect(local_transaction.devolved_administration_service?).to be true
      end
    end

    it "returns false when the country name hasn't been set" do
      expect(local_transaction.devolved_administration_service?).to be false
    end
  end

  describe "#devolved_administration_service_alternative_url" do
    it "returns the alternative url" do
      content_store_response["details"]["scotland_availability"] = {
        "type" => "devolved_administration_service",
        "alternative_url" => "https://www.gov.scot/stray-dog",
      }

      local_transaction.set_country("Scotland")

      expect(local_transaction.devolved_administration_service_alternative_url)
        .to eq("https://www.gov.scot/stray-dog")
    end

    it "returns nil when the service is unavailable" do
      content_store_response["details"]["scotland_availability"] = {
        "type" => "unavailable",
      }

      local_transaction.set_country("Scotland")

      expect(local_transaction.devolved_administration_service_alternative_url).to be_nil
    end

    it "does not return an alternative_url for a non devolved administration" do
      content_store_response["details"]["scotland_availability"] = {}
      content_store_response["details"]["wales_availability"] = {}
      content_store_response["details"]["northern_ireland_availability"] = {}

      expect(local_transaction.devolved_administration_service_alternative_url).to be_nil
    end
  end

  describe "#slug" do
    let(:content_store_response) do
      GovukSchemas::Example.find("local_transaction", example_name: "local_transaction").merge("base_path" => "/foo/bar")
    end

    it "returns the subject slug" do
      expect(local_transaction.slug).to eq("foo/bar")
    end
  end
end
