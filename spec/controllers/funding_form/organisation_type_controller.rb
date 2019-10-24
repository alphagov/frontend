RSpec.describe FundingForm::OrganisationTypeController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/organisation_type")
    end
  end

  describe "POST submit" do
    before do
      post :submit, params: {
        organisation_type: "business",
      }
    end

    it "sets session variables" do
      expect(session[:organisation_type]).to eq "business"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/organisation-details")
    end
  end
end
