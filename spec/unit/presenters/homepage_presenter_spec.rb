RSpec.describe HomepagePresenter do
  let(:content_item) do
    GovukSchemas::Example.find("homepage", example_name: "homepage_with_popular_links_on_govuk")
  end

  let(:subject) { described_class.new(content_item) }

  context "#links" do
    it "returns links" do
      expect(subject.links).to eq(content_item["links"])
    end
  end

  context "#popular_links" do
    context "when popular links in the content item" do
      it "memoizes popular links" do
        expected_popular_links = subject.popular_links
        content_item["links"].delete("popular_links")

        expect(subject.popular_links).to eq(expected_popular_links)
      end

      it "returns popular links from the content item" do
        expected_popular_links = content_item
          .dig("links", "popular_links", 0, "details", "link_items")
          .collect(&:with_indifferent_access)

        expect(subject.popular_links).to eq(expected_popular_links)
      end
    end

    context "when popular links not in the content item" do
      before do
        content_item["links"].delete("popular_links")
      end

      it "returns popular links from the locale file" do
        expected_popular_links = I18n.t("homepage.index.popular_links")
          .collect(&:with_indifferent_access)
        expect(subject.popular_links).to eq(expected_popular_links)
      end
    end
  end
end
