RSpec.describe LocalAuthorityPresenter do
  let(:local_authority_payload) do
    {
      "name" => "Westminster City Council",
      "snac" => "00BK",
      "gss" => "E060000034",
      "tier" => "district",
      "homepage_url" => "http://westminster.example.com/",
    }
  end

  let(:local_authority_presenter) { described_class.new(local_authority_payload) }

  describe "#exposed_attribute" do
    %i[name snac gss tier homepage_url].each do |exposed_attribute|
      it "exposes value of #{exposed_attribute} from payload via a method" do
        expect(local_authority_presenter).to respond_to(exposed_attribute)
        expect(local_authority_presenter.send(exposed_attribute)).to eq(local_authority_payload[exposed_attribute.to_s])
      end
    end
  end

  describe "#url" do
    context "when homepage_url is present" do
      it "exposes the homepage_url as the url" do
        expect(local_authority_presenter.url).to eq("http://westminster.example.com/")
      end
    end

    context "when homepage_url is blank" do
      let(:local_authority_payload) { { "name" => "Westminster City Council", "homepage_url" => "" } }

      it "exposes no url" do
        expect(local_authority_presenter.url).to be_nil
      end
    end
  end
end
