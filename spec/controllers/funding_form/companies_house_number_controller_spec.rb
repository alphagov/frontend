RSpec.describe FundingForm::CompaniesHouseNumberController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/companies_house_number")
    end
  end

  describe "POST submit" do
    it "sets session variables when no number is given" do
      post :submit, params: {
        company_house_or_charity_commision_number: "<script></script>No",
        company_house_or_charity_commision_number_other: "<script></script>",
      }

      expect(session[:company_house_or_charity_commision_number]).to eq "No"
    end

    it "sets session variables when a number is given" do
      post :submit, params: {
        company_house_or_charity_commision_number: "<script></script>Yes",
        company_house_or_charity_commision_number_other: "<script></script>1234",
      }

      expect(session[:company_house_or_charity_commision_number]).to eq "1234"
    end

    it "redirects to next step" do
      post :submit, params: {
        company_house_or_charity_commision_number: "<script></script>Yes",
        company_house_or_charity_commision_number_other: "<script></script>123",
      }

      expect(response).to redirect_to("/brexit-eu-funding/do-you-have-a-grant-agreement-number")
    end

    it "validates an option is chosen" do
      post :submit, params: {
        company_house_or_charity_commision_number: "",
      }

      expect(response).to render_template("funding_form/companies_house_number")
    end

    it "validates yes option is chosen" do
      post :submit, params: {
        company_house_or_charity_commision_number: "Yes",
        company_house_or_charity_commision_number_other: "",
      }

      expect(response).to render_template("funding_form/companies_house_number")
    end

    it "validates no option is chosen" do
      post :submit, params: {
        company_house_or_charity_commision_number: "No",
      }

      expect(response).to redirect_to("/brexit-eu-funding/do-you-have-a-grant-agreement-number")
    end
  end
end
