RSpec.describe ManualPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("manual", example_name: "content-design") }
  let(:content_item) { Manual.new(content_store_response) }
  let(:request) { instance_double(ActionDispatch::Request, path: request_path) }
  let(:display_date_text) { "27 April 2015" }
  let(:updates_path) { "#{content_item.base_path}/updates" }

  describe "#other_metadata" do
    context "when the request path is the updates page" do
      let(:request_path) { updates_path }

      it "returns only the updated date" do
        expect(presenter.other_metadata(request)).to eq(
          I18n.t("formats.manuals.updated") => display_date_text,
        )
      end
    end

    context "when the request path is not the updates page" do
      let(:request_path) { content_item.base_path }
      let(:updates_link) { "<a href='#{updates_path}' class='govuk-link'>See all updates</a>" }

      it "returns the updated date with a link to see all updates" do
        expect(presenter.other_metadata(request)).to eq(
          I18n.t("formats.manuals.updated") => "#{display_date_text} - #{updates_link}",
        )
      end
    end
  end
end
