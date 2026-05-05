RSpec.describe FlexiblePage::FlexibleSection::Breadcrumbs do
  subject(:breadcrumbs) { described_class.new(breadcrumbs: breadcrumb_params) }

  let(:breadcrumb_params) do
    [
      {
        title: "History of the UK Government",
        url: "/government/history",
      },
    ]
  end

  describe "#initialize" do
    it "sets the attributes from the parameters" do
      expect(breadcrumbs.breadcrumbs).to eq(breadcrumb_params)
    end
  end

  describe "#before_content?" do
    it "asks to be rendered in the before_content block" do
      expect(breadcrumbs.before_content?).to be true
    end
  end
end
