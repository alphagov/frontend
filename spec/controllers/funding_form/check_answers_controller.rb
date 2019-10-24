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
end
