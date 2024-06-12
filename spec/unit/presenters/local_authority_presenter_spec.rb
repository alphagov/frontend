RSpec.describe LocalAuthorityPresenter, type: :model do
  context "exposing attributes from the json payload" do
    before do
      @local_authority_payload = { "name" => "Westminster City Council", "snac" => "00BK", "gss" => "E060000034", "tier" => "district", "homepage_url" => "http://westminster.example.com/" }
      @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
    end

    %i[name snac gss tier homepage_url].each do |exposed_attribute|
      it "expose value of #{exposed_attribute} from payload via a method" do
        expect(@local_authority_presenter).to respond_to(exposed_attribute)
        expect(@local_authority_presenter.send(exposed_attribute)).to eq(@local_authority_payload[exposed_attribute.to_s])
      end
    end
  end

  describe "#url" do
    context "when homepage_url is present" do
      before do
        @local_authority_payload = { "name" => "Westminster City Council", "homepage_url" => "http://westminster.example.com/" }
        @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
      end

      it "exposes the homepage_url as the url" do
        expect(@local_authority_presenter.url).to eq("http://westminster.example.com/")
      end
    end

    context "when homepage_url is blank" do
      before do
        @local_authority_payload = { "name" => "Westminster City Council", "homepage_url" => "" }
        @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
      end

      it "exposes no url" do
        expect(@local_authority_presenter.url).to be_nil
      end
    end
  end
end
