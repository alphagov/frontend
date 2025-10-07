RSpec.describe Webchat do
  subject(:webchat) { described_class.new(content_store_response) }

  let(:content_store_response) do
    {
      "base_path" => "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
      "description" => "Handles the webchat view for HM Passport Office",
      "title" => "HM Passport Office webchat",
      "schema_name" => "special_route",
    }
  end

  describe "webchat attributes" do
    it "has an availability_url" do
      expect(webchat.availability_url).not_to be_nil
    end

    it "has an open_url" do
      expect(webchat.open_url).not_to be_nil
    end

    it "has a redirect_attribute" do
      expect(webchat.redirect_attribute).to eq("false")
    end
  end
end
