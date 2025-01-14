RSpec.describe "Contact Electoral Registration Office" do
  include ElectionHelpers

  before do
    content_store_has_example_item("/contact-electoral-registration-office", schema: "local_transaction", example: "local_transaction")
  end

  context "without postcode params" do
    it "GET show renders show page with form" do
      get "/contact-electoral-registration-office"

      expect(response).to have_http_status(:ok)
      expect(response).to render_template("local_transaction/index")
      expect(response).to render_template(partial: "application/_location_form")
      expect(response).to honour_content_store_ttl
    end
  end

  context "with postcode params" do
    context "when they map to a single address" do
      it "GET show renders results page" do
        elections_api_stub = stub_api_postcode_lookup("LS11UR", response: api_response)
        with_electoral_api_url do
          get "/contact-electoral-registration-office", params: { postcode: "LS11UR" }

          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:results)
          expect(elections_api_stub).to have_been_requested
          expect(response).to honour_content_store_ttl
        end
      end
    end

    context "when they map to multiple addresses" do
      before do
        allow(ElectoralPresenter).to receive(:new).and_return(presenter)
        response = { "address_picker" => true, "addresses" => [] }.to_json
        stub_api_postcode_lookup("IP224DN", response:)
      end

      context "and there are no contact details" do
        let(:presenter) { instance_double(ElectoralPresenter, show_picker?: true, addresses: []) }

        it "GET show renders the address picker template" do
          with_electoral_api_url do
            get "/contact-electoral-registration-office", params: { postcode: "IP224DN" }

            expect(response).to have_http_status(:ok)
            expect(response).to render_template(:address_picker)
          end
        end
      end

      context "but contact details are present" do
        let(:presenter) { instance_double(ElectoralPresenter, show_picker?: false, electoral_services: nil, use_electoral_services_contact_details?: false, use_registration_contact_details?: false) }

        it "GET show doesn't render the address picker template" do
          with_electoral_api_url do
            get "/contact-electoral-registration-office", params: { postcode: "IP224DN" }

            expect(response).to have_http_status(:ok)
            expect(response).to render_template(:results)
          end
        end
      end
    end
  end

  context "with uprn params" do
    it "GET show renders results page" do
      elections_api_stub = stub_api_address_lookup("1234", response: api_response)
      with_electoral_api_url do
        get "/contact-electoral-registration-office", params: { uprn: "1234" }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:results)
        expect(elections_api_stub).to have_been_requested
      end
    end
  end
end
