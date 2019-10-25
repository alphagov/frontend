RSpec.describe FundingForm::OrganisationTypeController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/organisation_type")
    end
  end

  describe "POST submit" do
    it "sets predefined option to session variables" do
      post :submit, params: {
        organisation_type: "business",
        organisation_type_other: "",
      }

      expect(session[:organisation_type]).to eq "business"
    end

    it "sets custom option to session variables" do
      post :submit, params: {
        organisation_type: "other",
        organisation_type_other: "Other organisation name",
      }

      expect(session[:organisation_type]).to eq "Other organisation name"
    end

    it "redirects to next step" do
      post :submit
      expect(response).to redirect_to("/brexit-eu-funding/organisation-details")
    end
  end
end
