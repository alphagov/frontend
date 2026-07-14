RSpec.describe Image do
  subject(:image) { described_class.new(image_hash) }

  let(:image_hash) { GovukSchemas::Example.find("history", example_name: "history")["details"]["images"].first }

  it "has a type" do
    expect(image.type).to eq("sidebar")
  end

  describe "#src" do
    it "returns the requested src" do
      expect(image.src(key: "s960")).to eq("https://assets.publishing.service.gov.uk/media/5a37daeaed915d5a5f96602b/s960_number10.jpg")
    end

    it "returns the default src (s300) if a key is not specified" do
      expect(image.src).to eq("https://assets.publishing.service.gov.uk/media/5a37dae940f0b649cceb1841/s300_number10.jpg")
    end

    it "returns nil if a src is not available" do
      expect(image.src(key: "s120")).to be_nil
    end
  end
end
