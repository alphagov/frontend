RSpec.describe FundingForm::ContactInformationController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/contact_information")
    end
  end

  describe "POST submit" do
    let(:params) do
      {
        full_name: "<script></script>Jane Smith",
        job_title: "<script></script>Grants Administrator",
        email_address: "<script></script>jane@smith.com",
        telephone_number: "<script></script>0123456789",
      }
    end

    it "sets sanitised session variables" do
      post :submit, params: params

      expect(session[:full_name]).to eq "Jane Smith"
      expect(session[:job_title]).to eq "Grants Administrator"
      expect(session[:email_address]).to eq "jane@smith.com"
      expect(session[:telephone_number]).to eq "0123456789"
    end

    it "redirects to next step" do
      post :submit, params: params

      expect(response).to redirect_to("/brexit-eu-funding/organisation-type")
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: params

      expect(response).to redirect_to("/brexit-eu-funding/check-your-answers")
    end

    it "catches missing mandatory fields" do
      params["full_name"] = ""
      params["job_title"] = ""
      params["email_address"] = ""
      params["telephone_number"] = ""
      post :submit, params: params

      expect(response).to render_template("funding_form/contact_information")
    end
  end
end
