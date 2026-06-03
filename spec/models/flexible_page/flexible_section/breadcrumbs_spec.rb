RSpec.describe FlexiblePage::FlexibleSection::Breadcrumbs do
  subject(:breadcrumbs) { described_class.new(breadcrumbs: breadcrumb_params, margin_bottom:, full_width:, background:) }

  let(:margin_bottom) { nil }
  let(:full_width) { nil }
  let(:background) { nil }
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

  describe "#margin_bottom" do
    let(:margin_bottom) { 1 }

    it "sets full width" do
      expect(breadcrumbs.margin_bottom).to be 1
    end
  end

  describe "#full_width" do
    let(:full_width) { true }

    it "sets full width" do
      expect(breadcrumbs.full_width).to be true
    end
  end

  describe "#background" do
    let(:background) { true }

    it "sets background" do
      expect(breadcrumbs.background).to be true
      expect(breadcrumbs.inverse).to be true
    end
  end
end
