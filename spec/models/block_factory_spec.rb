RSpec.describe BlockFactory do
  describe ".build" do
    it "builds blocks of the correct type" do
      expect(described_class.build({ "type" => "govspeak" }).type).to eq("govspeak")
    end
  end

  describe ".build_all" do
    it "builds many blocks" do
      result = described_class.build_all([
        { "type" => "govspeak" },
        { "type" => "govspeak" },
        { "type" => "govspeak" },
        { "type" => "govspeak" },
      ])
      expect(result.count).to eq(4)
      expect(result.map(&:type)).to eq(%w[govspeak govspeak govspeak govspeak])
    end
  end
end
