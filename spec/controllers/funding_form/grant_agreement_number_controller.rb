RSpec.describe FundingForm::GrantAgreementNumberController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/grant_agreement_number")
    end
  end

  describe "POST submit" do
    before do
      post :submit, params: {
        grant_agreement_number: "1234",
      }
    end

    it "sets session variables" do
      expect(session[:grant_agreement_number]).to eq "1234"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/what-programme-do-you-receive-funding-from")
    end
  end
end
