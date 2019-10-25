RSpec.describe FundingForm::PartnersController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/partners")
    end
  end

  describe "POST submit" do
    it "sets sanitised session variables" do
      post :submit, params: {
        partners_outside_uk: "<script></script>Yes",
      }

      expect(session[:partners_outside_uk]).to eq "Yes"
    end

    it "redirects to next step" do
      post :submit, params: {
        partners_outside_uk: "<script></script>Yes",
      }

      expect(response).to redirect_to("/brexit-eu-funding/check-your-answers")
    end

    it "validates an option is chosen" do
      post :submit, params: {
        partners_outside_uk: "",
      }

      expect(response).to render_template("funding_form/partners")
    end
  end
end
