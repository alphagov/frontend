RSpec.shared_examples "it can have manual metadata" do |content_item_class|
  subject(:presenter) { described_class.new(content_item) }

  let(:content_item) do
    instance_double(
      content_item_class,
      hmrc?: false,
      manual?: true,
      base_path: "/manuals-page",
      public_updated_at: Time.zone.parse("2025-10-01"),
      manual_content_item: instance_double(
        Manual,
        base_path: "/manuals-page",
      ),
    )
  end

  let(:request) { instance_double(ActionDispatch::Request, path: "/manuals-page") }

  before do
    allow(presenter).to receive_messages(
      display_date: "1 October 2025",
      govuk_styled_link: "<a href='/manuals-page/updates'>See all updates</a>",
    )
  end

  context "when the request link has only the base path" do
    expected_result = "1 October 2025 - <a href='/manuals-page/updates'>See all updates</a>"
    it "renders the updates link in the metadata" do
      expect(presenter.other_metadata(request)).to eq(
        I18n.t("formats.manuals.updated") => expected_result.to_s,
      )
    end
  end

  context "when the request link has updates" do
    let(:request) { instance_double(ActionDispatch::Request, path: "/manuals-page/updates") }

    expected_result = "1 October 2025"
    it "renders the updates link in the metadata" do
      expect(presenter.other_metadata(request)).to eq(
        I18n.t("formats.manuals.updated") => expected_result.to_s,
      )
    end
  end
end
