RSpec.describe FundingForm::GrantAgreementNumberController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/grant_agreement_number")
    end
  end

  describe "POST submit" do
    it "sets session variables where a grant agreement number is given" do
      post :submit, params: {
        grant_agreement_number: "Yes",
        grant_agreement_number_other: "1234",
      }

      expect(session[:grant_agreement_number]).to eq "1234"
    end

    it "sets session variables where a grant agreement number is not given" do
      post :submit, params: {
        grant_agreement_number: "No",
        grant_agreement_number_other: "",
      }

      expect(session[:grant_agreement_number]).to eq "No"
    end

    it "redirects to next step" do
      post :submit
      expect(response).to redirect_to("/brexit-eu-funding/what-programme-do-you-receive-funding-from")
    end
  end
end
