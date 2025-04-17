RSpec.describe Link do
  subject(:link) { described_class.new({ "href" => "#go", "text" => "Go" }) }

  describe "text attribute" do
    it "is set from the input" do
      expect(link.text).to eq("Go")
    end
  end

  describe "href attribute" do
    it "is set from the input" do
      expect(link.href).to eq("#go")
    end
  end
end
