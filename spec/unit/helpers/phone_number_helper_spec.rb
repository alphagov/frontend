RSpec.describe PhoneNumberHelper, type: :view do
  include PhoneNumberHelper

  before { @sample_phone_text = "023 4567 8910 (with some text)" }

  describe "#phone_digits" do
    it "returns the phone number" do
      expect(phone_digits(@sample_phone_text)).to eq("023 4567 8910")
    end
  end

  describe "#phone_text" do
    it "returns the text after the phone number" do
      expect(phone_text(@sample_phone_text)).to eq("(with some text)")
    end
  end
end
