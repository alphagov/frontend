RSpec.describe FundingForm::ProgrammeController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/programme")
    end
  end

  describe "POST submit" do
    before do
      post :submit, params: {
        funding_programme: "<script></script>Erasmus+",
      }
    end

    it "sets sanitised session variables" do
      expect(session[:funding_programme]).to eq "Erasmus+"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/project-details")
    end
  end
end
