RSpec.describe FundingForm::OrganisationDetailsController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/organisation_details")
    end
  end

  describe "POST submit" do
    before do
      post :submit, params: {
        organisation_name: "<script></script>Cabinet Office",
        address_line_1: "<script></script>70 Whitehall",
        address_line_2: "<script></script>Westminster",
        address_town: "<script></script>London",
        address_county: "<script></script>Greater London",
        address_postcode: "<script></script>SW1A 2AS",
      }
    end

    it "sets sanitised session variables" do
      expect(session[:organisation_name]).to eq "Cabinet Office"
      expect(session[:address_line_1]).to eq "70 Whitehall"
      expect(session[:address_line_2]).to eq "Westminster"
      expect(session[:address_town]).to eq "London"
      expect(session[:address_county]).to eq "Greater London"
      expect(session[:address_postcode]).to eq "SW1A 2AS"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/do-you-have-a-companies-house-or-charity-commission-number")
    end
  end
end
