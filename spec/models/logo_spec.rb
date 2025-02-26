RSpec.describe Logo do
  let(:logo) do
    {
      "crest": "dbt",
      "formatted_title": "Department for<br/>Business &amp; Trade",
    }
  end

  describe "logo" do
    it "gets the crest" do
      expect(described_class.new(logo).crest)
        .to eq(logo["crest"])
    end

    it "gets the formatted title" do
      expect(described_class.new(logo).formatted_title)
        .to eq(logo["formatted_title"])
    end
  end
end
