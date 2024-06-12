RSpec.describe ElectoralController, type: :controller do
  include(ElectionHelpers)

  render_views

  before do
    stub_content_store_has_item("/contact-electoral-registration-office")
  end

  context "without postcode params" do
    it "GET show renders show page with form" do
      get(:show)

      expect(response.ok?)
      expect(response).to render_template("local_transaction/index")
      expect(response).to render_template(partial: "application/_location_form")
      honours_content_store_ttl
    end
  end

  context "with postcode params" do
    context "that map to a single address" do
      it "GET show renders results page" do
        elections_api_stub = stub_api_postcode_lookup("LS11UR", response: api_response)
        with_electoral_api_url do
          get(:show, params: { postcode: "LS11UR" })

          assert_response(:success)
          assert_template(:results)
          assert_requested(elections_api_stub)
          honours_content_store_ttl
        end
      end
    end

    context "that maps to multiple addresses" do
      before do
        @response = { "address_picker" => true, "addresses" => [] }.to_json
        stub_api_postcode_lookup("IP224DN", response:)
      end

      context "and there are no contact details" do
        it "GET show renders the address picker template" do
          allow_any_instance_of(ElectoralPresenter).to receive(:show_picker?).and_return(true)
          with_electoral_api_url do
            get(:show, params: { postcode: "IP224DN" })

            assert_response(:success)
            assert_template(:address_picker)
          end
        end
      end

      context "but contact details are present" do
        it "GET show doesn't render the address picker template" do
          allow_any_instance_of(ElectoralPresenter).to receive(:show_picker?).and_return(false)
          with_electoral_api_url do
            get(:show, params: { postcode: "IP224DN" })

            assert_response(:success)
            assert_template(:results)
          end
        end
      end
    end
  end

  context "with uprn params" do
    it "GET show renders results page" do
      elections_api_stub = stub_api_address_lookup("1234", response: api_response)
      with_electoral_api_url do
        get(:show, params: { uprn: "1234" })

        assert_response(:success)
        assert_template(:results)
        assert_requested(elections_api_stub)
      end
    end
  end
end
