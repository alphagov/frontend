require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"
RSpec.describe LocalTransactionController, type: :controller do
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include(LocationHelpers)

  render_views

  it "does not allow framing of local transaction pages" do
    content_store_has_random_item(base_path: "/a-slug", schema: "local_transaction")
    get(:index, params: { slug: "a-slug" })

    expect(@response.headers["X-Frame-Options"]).to eq("DENY")
  end

  it "sets expiry headers for an edition" do
    content_store_has_random_item(base_path: "/a-slug", schema: "local_transaction")
    get(:index, params: { slug: "a-slug" })

    honours_content_store_ttl
  end

  context "given a local transaction exists in content store" do
    before do
      @payload_bear = { analytics_identifier: nil, base_path: "/pay-bear-tax", content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f", document_type: "local_transaction", first_published_at: "2016-02-29T09:24:10.000+00:00", format: "local_transaction", locale: "en", phase: "beta", public_updated_at: "2014-12-16T12:49:50.000+00:00", publishing_app: "publisher", rendering_app: "frontend", schema_name: "local_transaction", title: "Send a bear to your local council", updated_at: "2017-01-30T12:30:33.483Z", withdrawn_notice: {}, links: {}, description: "Descriptive bear text.", details: { lgsl_code: 8342, lgil_code: 8, service_tiers: %w[district unitary], introduction: "Infos about sending bears.", scotland_availability: { "type" => "devolved_administration_service", "alternative_url" => "https://www.scotland.gov/service" }, wales_availability: { "type" => "unavailable" } }, external_related_links: [] }
      @payload_electoral = { analytics_identifier: nil, base_path: "/get-on-electoral-register", content_id: "d6d6caaf-77db-47e1-8206-30cd4f3hwe78", document_type: "local_transaction", first_published_at: "2016-02-29T09:24:10.000+00:00", format: "local_transaction", locale: "en", phase: "beta", public_updated_at: "2014-12-16T12:49:50.000+00:00", publishing_app: "publisher", rendering_app: "frontend", schema_name: "local_transaction", title: "Get on electoral register", updated_at: "2017-01-30T12:30:33.483Z", withdrawn_notice: {}, links: {}, description: "Descriptive text.", details: { lgsl_code: 364, lgil_code: 8, service_tiers: %w[district unitary], introduction: "Infos about registering to vote." }, external_related_links: [] }
      stub_content_store_has_item("/send-a-bear-to-your-local-council", @payload_bear)
      stub_content_store_has_item("/get-on-electoral-register", @payload_electoral)
    end

    context "loading the local transaction edition without any location" do
      it "returns the normal content for a page" do
        get(:index, params: { slug: "send-a-bear-to-your-local-council" })

        assert_response(:success)
        expect("Send a bear to your local council").to eq(assigns(:publication).title)
      end

      it "sets correct expiry headers" do
        get(:index, params: { slug: "send-a-bear-to-your-local-council" })

        honours_content_store_ttl
      end
    end

    context "loading the local transaction when posting a location" do
      context "for an English local authority" do
        before do
          configure_locations_api_and_local_authority("ST10 4DB", %w[staffordshire staffordshire-moorlands], 3435)
          post(:find, params: { slug: "send-a-bear-to-your-local-council", postcode: "ST10-4DB] " })
        end

        it "redirects to the local authority slug" do
          assert_redirected_to("/send-a-bear-to-your-local-council/staffordshire-moorlands")
        end
      end

      context "for a Northern Ireland local authority" do
        before do
          configure_locations_api_and_local_authority("BT1 4QG", %w[belfast], 8132)
          post(:find, params: { slug: "send-a-bear-to-your-local-council", postcode: "BT1-4QG] " })
        end

        it "redirects to the local authority slug" do
          assert_redirected_to("/send-a-bear-to-your-local-council/belfast")
        end
      end

      context "for electoral registration for an English local authority" do
        before do
          configure_locations_api_and_local_authority("ST10 4DB", %w[staffordshire staffordshire-moorlands], 3435)
          post(:find, params: { slug: "get-on-electoral-register", postcode: "ST10-4DB] " })
        end

        it "redirects to the local authority slug" do
          assert_redirected_to("/get-on-electoral-register/staffordshire-moorlands")
        end
      end

      context "for electoral registration for a Northern Ireland local authority" do
        before do
          stub_locations_api_has_location("BT1 3QG", [{ "local_custodian_code" => 8132 }])
          stub_local_links_manager_has_a_local_authority("belfast", country_name: "Northern Ireland", local_custodian_code: 8132)
          post(:find, params: { slug: "get-on-electoral-register", postcode: "BT1-3QG] " })
        end

        it "redirects to the local authority slug" do
          assert_redirected_to("/get-on-electoral-register/electoral-office-for-northern-ireland")
        end
      end
    end

    context "loading the local transaction when posting an invalid postcode" do
      before do
        stub_locations_api_does_not_have_a_bad_postcode("BLAH")
        post(:find, params: { slug: "send-a-bear-to-your-local-council", postcode: "BLAH" })
      end

      it "responds successfully with an error message" do
        expect(response.ok?).to be true
        expect(response.body).to(match(CGI.escapeHTML(I18n.t!("formats.local_transaction.invalid_postcode"))))
      end
    end

    context "loading the local transaction when posting a postcode with no matching areas" do
      before do
        stub_locations_api_has_no_location("WC1E 9ZZ")
        post(:find, params: { slug: "send-a-bear-to-your-local-council", postcode: "WC1E 9ZZ" })
      end

      it "responds successfully with an error message" do
        expect(response.ok?).to be true
        expect(response.body).to(match(CGI.escapeHTML(I18n.t!("formats.local_transaction.valid_postcode_no_match"))))
      end
    end

    context "loading the local transaction when posting a location that has no matching local authority" do
      before do
        stub_locations_api_has_location("AB1 2CD", [{ "local_custodian_code" => 123 }])
        stub_local_links_manager_does_not_have_a_custodian_code(123)
        post(:find, params: { slug: "send-a-bear-to-your-local-council", postcode: "AB1 2CD" })
      end

      it "responds successfully with an error message" do
        expect(response.ok?).to be true
        expect(response.body).to(match(CGI.escapeHTML(I18n.t!("formats.local_transaction.no_local_authority"))))
      end
    end

    context "loading the local transaction for an authority" do
      before do
        configure_locations_api_and_local_authority("ST10 4DB", %w[staffordshire-moorlands], 3435)
        stub_local_links_manager_has_a_link(authority_slug: "staffordshire-moorlands", lgsl: 8342, lgil: 8, url: "http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks", country_name: "England", status: "pending")
      end

      it "assigns local transaction information" do
        get(:results, params: { slug: "send-a-bear-to-your-local-council", local_authority_slug: "staffordshire-moorlands" })

        expect(assigns(:interaction_details)["local_interaction"]["url"]).to eq("http://www.staffsmoorlands.gov.uk/sm/council-services/parks-and-open-spaces/parks")
      end

      it "assigns link status" do
        get(:results, params: { slug: "send-a-bear-to-your-local-council", local_authority_slug: "staffordshire-moorlands" })

        expect(assigns(:interaction_details)["local_interaction"]["status"]).to eq("pending")
      end
    end

    it "returns a 404 for an incorrect authority slug" do
      stub_local_links_manager_request_with_invalid_parameters(authority_slug: "this-slug-should-not-exist", lgsl: "8342", lgil: "8")
      get(:results, params: { slug: "send-a-bear-to-your-local-council", local_authority_slug: "this-slug-should-not-exist" })

      expect(response.status).to eq(404)
    end
  end

  context "loading a local transaction without an interaction that exists in content store" do
    before do
      @payload = { analytics_identifier: nil, base_path: "/report-a-bear-on-a-local-road", content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f", document_type: "local_transaction", first_published_at: "2016-02-29T09:24:10.000+00:00", format: "local_transaction", locale: "en", phase: "beta", public_updated_at: "2014-12-16T12:49:50.000+00:00", publishing_app: "publisher", rendering_app: "frontend", schema_name: "local_transaction", title: "Send a bear to your local council", updated_at: "2017-01-30T12:30:33.483Z", withdrawn_notice: {}, links: {}, description: "Descriptive bear text.", details: { lgsl_code: 1234, lgil_code: 1, service_tiers: %w[district unitary], introduction: "Infos about sending bears." }, external_related_links: [] }
      configure_locations_api_and_local_authority("ST10 4DB", %w[staffordshire-moorlands], 3435)
      stub_local_links_manager_has_no_link(authority_slug: "staffordshire-moorlands", lgsl: 1234, lgil: 1, country_name: "England")
      stub_content_store_has_item("/report-a-bear-on-a-local-road", @payload)
      get(:results, params: { slug: "report-a-bear-on-a-local-road", local_authority_slug: "staffordshire-moorlands" })
    end

    it "responds successfully with an error message" do
      expect(response.ok?).to be true
      expect(response.body).to(match("We do not know if they offer this service"))
    end
  end

  context "when visiting a local transaction which is in fact check" do
    before do
      stub_locations_api_has_location("SW1A 1AA", [{ "latitude" => 51.5010096, "longitude" => -0.141587, "local_custodian_code" => 5990 }])
      stub_local_links_manager_has_a_local_authority("westminster", local_custodian_code: 5990)
      stub_local_links_manager_has_a_link(authority_slug: "westminster", lgsl: 461, lgil: 8, url: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update", country_name: "England", status: "ok")
      @payload = { base_path: "/pay-bear-tax", document_type: "local_transaction", format: "local_transaction", schema_name: "local_transaction", details: { lgsl_code: 461, lgil_code: 8, service_tiers: %w[county unitary], introduction: "Information about paying local tax on owning or looking after a bear." } }
      stub_content_store_has_item("/pay-bear-tax", @payload)
    end

    it "redirects to the correct authority and pass cache and token as params" do
      post(:find, params: { slug: "pay-bear-tax", postcode: "SW1A 1AA", token: "123", cache: "abc" })

      assert_redirected_to("/pay-bear-tax/westminster?cache=abc&token=123")
    end
  end
end
