RSpec.describe ElectoralPresenter, type: :model do
  def api_response
    path = Rails.root.join("spec/fixtures/electoral-result.json")
    fixture = File.read(path)
    JSON.parse(fixture)
  end

  def electoral_presenter(payload)
    ElectoralPresenter.new(payload)
  end

  context "exposing attributes from the json payload" do
    ElectoralPresenter::EXPECTED_KEYS.each do |exposed_attribute|
      it "exposes the value of #{exposed_attribute} from payload via a method" do
        subject = electoral_presenter(api_response)

        expect(subject.respond_to?(exposed_attribute)).to be true
        expect(subject.send(exposed_attribute)).to eq(api_response[exposed_attribute])
      end
    end
  end

  context "presenting addresses" do
    context "when duplicate contact details are provided" do
      it "does not show the electoral services address" do
        with_duplicate_contact = api_response
        with_duplicate_contact["registration"] = { "address" => "foo bar" }
        with_duplicate_contact["electoral_services"] = { "address" => " foo  bar " }
        subject = electoral_presenter(with_duplicate_contact)

        expect(subject.use_electoral_services_contact_details?).to be false
      end
    end

    context "when both contact details are different" do
      it "shows both addresses" do
        with_different_contact = api_response
        with_different_contact["registration"] = { "address" => "foo bar" }
        with_different_contact["electoral_services"] = { "address" => " baz boo " }
        subject = electoral_presenter(with_different_contact)

        expect(subject.use_electoral_services_contact_details?).to be true
        expect(subject.use_registration_contact_details?).to be true
      end
    end

    describe "#show_picker?" do
      context "when address picker is present in the api response" do
        before do
          @with_address_picker = api_response
          @with_address_picker["address_picker"] = true
        end

        context "address details are present" do
          it "returns true" do
            with_no_contact_details = @with_address_picker
            with_no_contact_details["registration"] = nil
            with_no_contact_details["electoral_services"] = nil
            subject = electoral_presenter(with_no_contact_details)

            expect(subject.show_picker?).to be true
          end
        end

        context "address details are missing" do
          it "returns false" do
            subject = electoral_presenter(@with_address_picker)

            expect(subject.show_picker?).to be false
          end
        end
      end
    end
  end
end
