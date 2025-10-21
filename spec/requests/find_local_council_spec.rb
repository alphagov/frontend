require "gds_api/test_helpers/local_links_manager"

RSpec.describe "Find Local Council" do
  include LocationHelpers

  before { content_store_has_random_item(base_path: "/find-local-council") }

  it "sets correct expiry headers" do
    get "/find-local-council"

    expect(response).to honour_content_store_ttl
  end

  describe "local authority results pages" do
    context "when the local authority slug can't be found" do
      before do
        stub_local_links_manager_does_not_have_an_authority("foo")
        get "/find-local-council/foo"
      end

      it "returns a 404" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the local authority requested is a unitary body" do
      before do
        stub_local_links_manager_has_a_local_authority("richmond-upon-thames")
        get "/find-local-council/richmond-upon-thames"
      end

      it "returns a 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the local authority requested is a county" do
      before do
        stub_local_links_manager_has_a_county("essex")
        get "/find-local-council/essex"
      end

      it "returns a 200" do
        expect(response).to redirect_to("/find-local-council")
      end
    end

    context "when the local authority requested is a district" do
      before do
        stub_local_links_manager_has_a_district_and_county_local_authority("uttlesford", "essex")
        get "/find-local-council/uttlesford"
      end

      it "returns a 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
