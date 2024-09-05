RSpec.describe LinksHelper do
  include LinksHelper

  describe "#feed_link" do
    it "appends .atom to the base_path" do
      expect(feed_link("/base_path")).to eq("/base_path.atom")
    end
  end

  describe "#print_link" do
    it "appends /print to the base_path" do
      expect(print_link("/base_path")).to eq("/base_path/print")
    end
  end
end
