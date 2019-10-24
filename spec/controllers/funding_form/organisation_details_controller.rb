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
        organisation_name: "Cabinet Office",
        company_house_or_charity_commission_number: "1234",
        address_line_1: "70 Whitehall",
        address_line_2: "Westminster",
        address_town: "London",
        address_county: "Greater London",
        address_postcode: "SW1A 2AS",
      }
    end

    it "sets session variables" do
      expect(session[:organisation_name]).to eq "Cabinet Office"
      expect(session[:company_house_or_charity_commission_number]).to eq "1234"
      expect(session[:address_line_1]).to eq "70 Whitehall"
      expect(session[:address_line_2]).to eq "Westminster"
      expect(session[:address_town]).to eq "London"
      expect(session[:address_county]).to eq "Greater London"
      expect(session[:address_postcode]).to eq "SW1A 2AS"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/do-you-have-a-grant-agreement-number")
    end
  end
end
