RSpec.describe Homepage do
  before do
    @content_store_response = GovukSchemas::Example.find("homepage", example_name: "homepage_with_popular_links_on_govuk")
  end

  let(:subject) { described_class.new(@content_store_response) }

  describe "#popular_links" do
    context "when popular links in the content item" do
      it "returns popular links from the content item" do
        expected_popular_links = @content_store_response
          .dig("links", "popular_links", 0, "details", "link_items")
          .collect(&:with_indifferent_access)

        expect(subject.popular_links).to eq(expected_popular_links)
      end
    end
  end
end
