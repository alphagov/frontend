RSpec.describe FlexiblePage::FlexibleSectionFactory do
  describe ".build" do
    it "builds sections of the correct type" do
      expect(described_class.build({ "type" => "base" }, FlexiblePage.new({}))).to be_instance_of(FlexiblePage::FlexibleSection::Base)
    end

    it "raises an error if the section type is not recognised" do
      expect { described_class.build({ "type" => "broken" }, FlexiblePage.new({})) }.to raise_error(StandardError, "Couldn't identify a model class for type: broken")
    end
  end
end
