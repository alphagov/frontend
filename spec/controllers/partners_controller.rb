RSpec.describe FundingForm::PartnersController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/partners")
    end
  end

  describe "POST submit" do
    before do
      post :submit, params: {
        partners_outside_uk: "Yes",
      }
    end

    it "sets session variables" do
      expect(session[:partners_outside_uk]).to eq "Yes"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/check-your-answers")
    end
  end
end
