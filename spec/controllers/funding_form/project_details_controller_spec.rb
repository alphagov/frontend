RSpec.describe FundingForm::ProjectDetailsController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/project_details")
    end
  end

  describe "POST submit" do
    let(:params) do
      {
        project_name: "<script></script>Researching something interesting",
        total_amount_awarded: "<script></script>1000000",
        start_date_day: "10",
        start_date_month: "6",
        start_date_year: "2019",
        end_date_day: "4",
        end_date_month: "7",
        end_date_year: "2021",
      }
    end

    it "sets sanitised session variables" do
      post :submit, params: params

      expect(session[:project_name]).to eq "Researching something interesting"
      expect(session[:total_amount_awarded]).to eq "1000000"
      expect(session[:award_start_date]).to eq "2019-06-10"
      expect(session[:award_end_date]).to eq "2021-07-04"
    end

    it "redirects to next step" do
      post :submit, params: params

      expect(response).to redirect_to("/brexit-eu-funding/does-the-project-have-partners-or-participants-outside-the-uk")
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: params

      expect(response).to redirect_to("/brexit-eu-funding/check-your-answers")
    end

    it "catches missing mandatory fields" do
      params["project_name"] = ""
      post :submit, params: params

      expect(response).to render_template("funding_form/project_details")
    end

    it "catches an invalid amount of money" do
      params["total_amount_awarded"] = "One million euros"
      post :submit, params: params

      expect(response).to render_template("funding_form/project_details")
    end

    it "catches an invalid date" do
      params["start_date_day"] = "A"
      params["start_date_month"] = "A"
      params["start_date_year"] = "A"
      params["end_date_day"] = "A"
      params["end_date_month"] = "A"
      params["end_date_year"] = "A"
      post :submit, params: params

      expect(response).to render_template("funding_form/project_details")
    end
  end
end
