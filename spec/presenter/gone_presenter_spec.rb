RSpec.describe GonePresenter do
  let(:content_store_response) { GovukSchemas::Example.find("gone", example_name: "gone") }
  let(:content_item) { Gone.new(content_store_response.merge({ title: "Something" })) }
  let(:presenter) { described_class.new(content_item) }

  describe "#page_title_options" do
    it "has a heading that differs from the content item" do
      expect(content_item.content_store_response[:title]).to eq("Something")
      expect(presenter.page_title_options[:heading_text]).to eq("The page you're looking for is no longer available")
    end

    it "translates the heading according to the locale" do
      I18n.locale = :cy
      expect(content_item.content_store_response[:title]).to eq("Something")
      expect(presenter.page_title_options[:heading_text]).to eq("Dydy'r dudalen rydych chi'n chwilio amdani ddim ar gael mwyach")
      I18n.locale = :en
    end
  end
end
