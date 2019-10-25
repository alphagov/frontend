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

  describe "POST submit" do
    before do
      allow_any_instance_of(described_class).to receive(:reference_number).and_return("ABC")
    end

    it "queues up two emails" do
      expect {
        post :submit
      }.to have_enqueued_job.on_queue("mailers").twice

      confirmation_email = ActiveJob::Base.queue_adapter.enqueued_jobs.first
      expect(confirmation_email[:args].first).to eq("FundingFormMailer")
      expect(confirmation_email[:args].second).to eq("confirmation_email")

      department_email = ActiveJob::Base.queue_adapter.enqueued_jobs.second
      expect(department_email[:args].first).to eq("FundingFormMailer")
      expect(department_email[:args].second).to eq("department_email")
    end

    it "redirects to next step" do
      post :submit
      expect(response).to redirect_to(controller: "funding_form/confirmation", action: :show, reference_number: "ABC")
    end
  end
end
