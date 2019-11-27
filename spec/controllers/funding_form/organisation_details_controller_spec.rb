RSpec.describe FundingForm::OrganisationDetailsController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/organisation_details")
    end
  end

  describe "POST submit" do
    let(:params) do
      {
        organisation_name: "<script></script>Cabinet Office",
        address_line_1: "<script></script>70 Whitehall",
        address_line_2: "<script></script>Westminster",
        address_town: "<script></script>London",
        address_county: "<script></script>Greater London",
        address_postcode: "<script></script>SW1A 2AS",
      }
    end

    it "sets sanitised session variables" do
      post :submit, params: params

      expect(session[:organisation_name]).to eq "Cabinet Office"
      expect(session[:address_line_1]).to eq "70 Whitehall"
      expect(session[:address_line_2]).to eq "Westminster"
      expect(session[:address_town]).to eq "London"
      expect(session[:address_county]).to eq "Greater London"
      expect(session[:address_postcode]).to eq "SW1A 2AS"
    end

    it "redirects to next step" do
      post :submit, params: params

      expect(response).to redirect_to("/brexit-eu-funding/do-you-have-a-company-or-charity-registration-number")
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: params

      expect(response).to redirect_to("/brexit-eu-funding/check-your-answers")
    end

    it "catches missing mandatory fields" do
      params["organisation_name"] = ""
      params["address_line_1"] = ""
      params["address_town"] = ""
      params["address_postcode"] = ""
      post :submit, params: params

      expect(response).to render_template("funding_form/organisation_details")
    end
  end
end
