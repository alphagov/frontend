RSpec.describe ErrorItemsHelper do
  include described_class

  before do
    flash[:validation] = [
      { field: "full_name", text: "Enter full name" },
      { field: "job_title", text: "Enter job title" },
    ]
  end

  describe "#error_items" do
    it "contains error items" do
      expect(error_items("job_title")).to eq("Enter job title")
      expect(error_items("email_address")).to be_nil
    end
  end
end
