RSpec.describe FundingForm::OrganisationTypeController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/organisation_type")
    end
  end

  describe "POST submit" do
    it "sets predefined option to sanitised session variables" do
      post :submit, params: {
        organisation_type: "<script></script>Business",
        organisation_type_other: "<script></script>",
      }

      expect(session[:organisation_type]).to eq "Business"
      expect(session[:organisation_type_other]).to eq ""
    end

    it "sets custom option to sanitised session variables" do
      post :submit, params: {
        organisation_type: "<script></script>Other",
        organisation_type_other: "<script></script>Other organisation name",
      }

      expect(session[:organisation_type]).to eq "Other"
      expect(session[:organisation_type_other]).to eq "Other organisation name"
    end

    it "redirects to next step" do
      post :submit, params: {
        organisation_type: "<script></script>business",
        organisation_type_other: "<script></script>",
      }

      expect(response).to redirect_to("/brexit-eu-funding/organisation-details")
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: {
        organisation_type: "<script></script>business",
        organisation_type_other: "<script></script>",
      }

      expect(response).to redirect_to("/brexit-eu-funding/check-your-answers")
    end

    it "validates an option is chosen" do
      post :submit, params: {
        organisation_type: "",
      }

      expect(response).to render_template("funding_form/organisation_type")
    end

    it "validates other option is chosen" do
      post :submit, params: {
        organisation_type: "Other",
        organisation_type_other: "",
      }

      expect(response).to render_template("funding_form/organisation_type")
    end
  end
end
