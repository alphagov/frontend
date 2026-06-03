RSpec.describe FlexiblePage::FlexibleSection::Breadcrumbs do
  subject(:model) { described_class.new(breadcrumbs_options:, full_width:, background:) }

  let(:breadcrumb_params) do
    [
      {
        title: "History of the UK Government",
        url: "/government/history",
      },
    ]
  end
  let(:breadcrumbs_options) do
    { breadcrumbs: breadcrumb_params }
  end
  let(:full_width) { nil }
  let(:background) { nil }

  describe "#initialize" do
    it "sets the attributes from the parameters" do
      expect(model.breadcrumbs_options).to eq(
        {
          collapse_on_mobile: true,
          margin_bottom: 8,
          breadcrumbs: breadcrumb_params,
        },
      )
    end
  end

  describe "#before_content?" do
    it "asks to be rendered in the before_content block" do
      expect(model.before_content?).to be true
    end
  end

  describe "#margin_bottom" do
    let(:breadcrumbs_options) do
      {
        breadcrumbs: breadcrumb_params,
        margin_bottom: 1,
      }
    end

    it "sets margin bottom on the breadcrumbs component" do
      expect(model.breadcrumbs_options[:margin_bottom]).to be 1
    end
  end

  describe "#full_width" do
    let(:full_width) { true }

    it "sets full width" do
      expect(model.full_width).to be true
    end
  end

  describe "#background" do
    let(:background) { true }

    it "sets background" do
      expect(model.background).to be true
      expect(model.breadcrumbs_options[:inverse]).to be true
    end
  end
end
