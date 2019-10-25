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
        grant_agreement_number: "<script></script>Yes",
        grant_agreement_number_other: "<script></script>1234",
      }

      expect(session[:grant_agreement_number]).to eq "1234"
    end

    it "sets sanitised session variables where a grant agreement number is not given" do
      post :submit, params: {
        grant_agreement_number: "No",
        grant_agreement_number_other: "",
      }

      expect(session[:grant_agreement_number]).to eq "No"
    end

    it "redirects to next step" do
      post :submit, params: {
        grant_agreement_number: "<script></script>Yes",
        grant_agreement_number_other: "<script></script>1234",
      }

      expect(response).to redirect_to("/brexit-eu-funding/what-programme-do-you-receive-funding-from")
    end

    it "validates an option is chosen" do
      post :submit, params: {
        grant_agreement_number: "",
      }

      expect(response).to render_template("funding_form/grant_agreement_number")
    end

    it "validates yes option is chosen" do
      post :submit, params: {
        grant_agreement_number: "Yes",
        grant_agreement_number_other: "",
      }

      expect(response).to render_template("funding_form/grant_agreement_number")
    end

    it "validates no option is chosen" do
      post :submit, params: {
        grant_agreement_number: "No",
      }

      expect(response).to redirect_to("/brexit-eu-funding/what-programme-do-you-receive-funding-from")
    end
  end
end
