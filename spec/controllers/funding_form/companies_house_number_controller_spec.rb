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
        companies_house_or_charity_commission_number: "<script></script>No",
        companies_house_or_charity_commission_number_other: "<script></script>",
      }

      expect(session[:companies_house_or_charity_commission_number]).to eq "No"
    end

    it "sets session variables when a number is given" do
      post :submit, params: {
        companies_house_or_charity_commission_number: "<script></script>Yes",
        companies_house_or_charity_commission_number_other: "<script></script>1234",
      }

      expect(session[:companies_house_or_charity_commission_number]).to eq "1234"
    end

    it "redirects to next step" do
      post :submit, params: {
        companies_house_or_charity_commission_number: "<script></script>Yes",
        companies_house_or_charity_commission_number_other: "<script></script>123",
      }

      expect(response).to redirect_to("/brexit-eu-funding/do-you-have-a-grant-agreement-number")
    end

    it "validates an option is chosen" do
      post :submit, params: {
        companies_house_or_charity_commission_number: "",
      }

      expect(response).to render_template("funding_form/companies_house_number")
    end

    it "validates yes option is chosen" do
      post :submit, params: {
        companies_house_or_charity_commission_number: "Yes",
        companies_house_or_charity_commission_number_other: "",
      }

      expect(response).to render_template("funding_form/companies_house_number")
    end

    it "validates no option is chosen" do
      post :submit, params: {
        companies_house_or_charity_commission_number: "No",
      }

      expect(response).to redirect_to("/brexit-eu-funding/do-you-have-a-grant-agreement-number")
    end
  end
end
