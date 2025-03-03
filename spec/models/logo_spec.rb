RSpec.describe Logo do
  let(:logo) do
    {
      "crest" => "dbt",
      "formatted_title" => "Department for<br/>Business &amp; Trade",
    }
  end

  describe "#crest" do
    it "gets the crest" do
      expect(described_class.new(logo).crest)
        .to eq(logo["crest"])
    end
  end

  describe "#formatted_title" do
    it "gets the formatted title" do
      expect(described_class.new(logo).formatted_title)
        .to eq(logo["formatted_title"])
    end
  end

  describe "#image" do
    context "when there is an image" do
      let(:logo) do
        {
          "formatted_title" => "Forensic Science <br/>Regulator",
          "image" => {
            "alt_text" => "Forensic Science Regulator",
            "url" => "https://example.com/sample.png",
          },
        }
      end

      it "gets the image alt_text" do
        expect(described_class.new(logo).image.alt_text).to eq(logo["image"]["alt_text"])
      end

      it "gets the image url" do
        expect(described_class.new(logo).image.url).to eq(logo["image"]["url"])
      end
    end

    context "when there is no image" do
      it "returns nil" do
        expect(described_class.new(logo).image).to be_nil
      end
    end
  end
end
