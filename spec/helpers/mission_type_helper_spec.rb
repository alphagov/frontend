RSpec.describe MissionTypeHelper do
  include MissionTypeHelper

  describe "no mission type" do
    it "returns mission type style 1" do
      expect(MissionTypeHelper.style("")).to eq("mission-1")
    end
  end

  describe "mission 2" do
    it "returns mission type style 2" do
      expect(MissionTypeHelper.style(2)).to eq("mission-2")
    end
  end
end
