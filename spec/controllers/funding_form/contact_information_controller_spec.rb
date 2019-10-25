RSpec.describe FundingForm::ContactInformationController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/contact_information")
    end
  end

  describe "POST submit" do
    before do
      post :submit, params: {
        full_name: "Jane Smith",
        job_title: "Grants Administrator",
        email_address: "jane@smith.com",
        telephone_number: "0123456789",
      }
    end

    it "sets session variables" do
      expect(session[:full_name]).to eq"Jane Smith"
      expect(session[:job_title]).to eq"Grants Administrator"
      expect(session[:email_address]).to eq"jane@smith.com"
      expect(session[:telephone_number]).to eq"0123456789"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/organisation-type")
    end
  end
end
