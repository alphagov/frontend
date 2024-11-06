RSpec.describe Sanitiser::Strategy do
  context "with sanitize_null_bytes true" do
    it "raises an error if the string contains a null byte" do
      expect { described_class.call("Hello\x00World!", sanitize_null_bytes: true) }.to raise_error(Sanitiser::Strategy::SanitisingError)
    end
  end

  context "with sanitize_null_bytes false" do
    it "does not raise an error if the string contains a null byte" do
      expect { described_class.call("Hello\x00World!", sanitize_null_bytes: false) }.not_to raise_error
    end
  end
end
