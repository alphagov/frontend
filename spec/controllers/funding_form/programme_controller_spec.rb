RSpec.describe FundingForm::ProgrammeController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/programme")
    end
  end

  describe "POST submit" do
    it "sets sanitised session variables" do
      post :submit, params: {
        funding_programme: "<script></script>Erasmus+",
      }

      expect(session[:funding_programme]).to eq "Erasmus+"
    end

    it "redirects to next step" do
      post :submit, params: {
        funding_programme: "<script></script>Erasmus+",
      }

      expect(response).to redirect_to("/brexit-eu-funding/project-details")
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: {
        funding_programme: "<script></script>Erasmus+",
      }

      expect(response).to redirect_to("/brexit-eu-funding/check-your-answers")
    end

    it "validates an option is chosen" do
      post :submit, params: {
        funding_programme: "",
      }

      expect(response).to render_template("funding_form/programme")
    end
  end
end
