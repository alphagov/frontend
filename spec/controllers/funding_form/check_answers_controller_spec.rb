RSpec.describe FundingForm::CheckAnswersController do
  describe "reference number" do
    before do
      allow(SecureRandom).to receive(:hex).and_return("ABCDEFG")
    end

    it "generates a part-random reference" do
      Timecop.freeze("2019-07-04 09:03:54") do
        expect(described_class.new.reference_number).to eq "20190704-090354-ABCDEFG"
      end
    end
  end

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template("funding_form/check_answers")
    end

    it "sets a session variable" do
      get :show
      expect(session[:check_answers_seen]).to be true
    end
  end

  describe "POST submit" do
    before do
      session[:email_address] = "grant_recipient@digital.cabinet-office.gov.uk"
      allow_any_instance_of(described_class).to receive(:reference_number).and_return("ABC")
    end

    after do
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    end

    it "queues up two emails for fund with one recipient" do
      session[:funding_programme] = "Competitiveness of Small and Medium-Sized Enterprises (COSME)"

      expect {
        post :submit
      }.to have_enqueued_job.on_queue("mailers").twice

      confirmation_email = ActiveJob::Base.queue_adapter.enqueued_jobs.first
      expect(confirmation_email[:args].first).to eq("FundingFormMailer")
      expect(confirmation_email[:args].second).to eq("confirmation_email")
      expect(confirmation_email[:args].last).to eq("grant_recipient@digital.cabinet-office.gov.uk")

      department_email = ActiveJob::Base.queue_adapter.enqueued_jobs.second
      expect(department_email[:args].first).to eq("FundingFormMailer")
      expect(department_email[:args].second).to eq("department_email")
      expect(department_email[:args].last).to eq("COSMEgrants@beis.gov.uk")
    end

    it "queues up three emails for fund with two recipients" do
      session[:funding_programme] = "European Solidarity Corps"

      expect {
        post :submit
      }.to have_enqueued_job.on_queue("mailers").exactly(3).times

      confirmation_email = ActiveJob::Base.queue_adapter.enqueued_jobs.first
      expect(confirmation_email[:args].first).to eq("FundingFormMailer")
      expect(confirmation_email[:args].second).to eq("confirmation_email")
      expect(confirmation_email[:args].last).to eq("grant_recipient@digital.cabinet-office.gov.uk")

      department_email_one = ActiveJob::Base.queue_adapter.enqueued_jobs.second
      expect(department_email_one[:args].first).to eq("FundingFormMailer")
      expect(department_email_one[:args].second).to eq("department_email")
      expect(department_email_one[:args].last).to eq("andrew.hodgetts@culture.gov.uk")

      department_email_two = ActiveJob::Base.queue_adapter.enqueued_jobs.third
      expect(department_email_two[:args].first).to eq("FundingFormMailer")
      expect(department_email_two[:args].second).to eq("department_email")
      expect(department_email_two[:args].last).to eq("ocseusubteam@culture.gov.uk")
    end

    it "redirects to next step" do
      post :submit
      expect(response).to redirect_to(controller: "funding_form/confirmation", action: :show, reference_number: "ABC")
    end
  end
end
