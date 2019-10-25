RSpec.describe FundingForm::ProjectDetailsController do
  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/project_details")
    end
  end

  describe "POST submit" do
    before do
      post :submit, params: {
        project_name: "Researching something interesting",
        total_amount_awarded: "1000000",
        start_date_day: "10",
        start_date_month: "6",
        start_date_year: "2019",
        end_date_day: "4",
        end_date_month: "7",
        end_date_year: "2021",
      }
    end

    it "sets session variables" do
      expect(session[:project_name]).to eq "Researching something interesting"
      expect(session[:total_amount_awarded]).to eq "1000000"
      expect(session[:start_date]).to eq "2019-06-10"
      expect(session[:end_date]).to eq "2021-07-04"
    end

    it "redirects to next step" do
      expect(response).to redirect_to("/brexit-eu-funding/does-the-project-have-partners-or-participants-outside-the-uk")
    end
  end
end
