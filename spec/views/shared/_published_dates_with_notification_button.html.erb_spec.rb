RSpec.describe "published dates with notification button" do
  let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide") }

  let(:content_item) { FakeContentItem.new(content_store_response) }

  before do
    assign(:content_item, content_item)
  end

  context "when there is single page notification button" do
    it "renders the email and print link text" do
      allow(content_item).to receive(:display_single_page_notification_button?).and_return(true)

      render partial: "shared/published_dates_with_notification_button", locals: { content_item: content_item }

      expect(rendered).to include(I18n.t("common.email_and_print_link"))
    end
  end

  context "when there is no single page notification button" do
    it "renders the print link text only" do
      allow(content_item).to receive(:display_single_page_notification_button?).and_return(false)

      render partial: "shared/published_dates_with_notification_button", locals: { content_item: content_item }

      expect(rendered).to include(I18n.t("common.print_link"))
    end
  end
end

# To remove this once DetailedGuide PR is made

class FakeContentItem < ContentItem
  attr_reader :initial_publication_date, :updated, :history, :base_path

  def initialize(content_store_response)
    super(content_store_response)
    @initial_publication_date = content_store_response["first_published_at"]
    @updated = content_store_response["updated_at"]
    @history = content_store_response["history"] || []
    @base_path = content_store_response["base_path"]
  end
end
