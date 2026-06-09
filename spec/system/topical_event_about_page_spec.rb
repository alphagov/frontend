RSpec.describe "Topical Event About Page" do
  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "topical-event-with-about-page") }
  let(:base_path) { "#{content_store_response.fetch('base_path')}/about" }

  before do
    stub_conditional_loader_returns_content_item_for_path(base_path, content_store_response)

    visit base_path
  end

  describe "basic page information" do
    it "has a page title" do
      expect(page).to have_title(content_store_response["details"]["about"]["title"])
    end

    it "has a lead paragraph taken from the description" do
      expect(page).to have_text(content_store_response["details"]["about"]["summary"])
    end

    it "has body text" do
      expect(page).to have_text(content_store_response["details"]["about"]["body"])
    end
  end

  describe "contents list" do
    context "when headers are present" do
      it "has a contents list" do
        expect(page).to have_selector(".gem-c-contents-list", text: "Contents")
        expected_headers = content_store_response["details"]["about"]["headers"].select { it["level"] == 2 }.map(&:deep_symbolize_keys)

        within ".gem-c-contents-list" do
          expected_headers.each do |heading|
            selector = "a[href=\"##{heading[:id]}\"]"
            text = heading.fetch(:text)
            expect(page).to have_selector(selector)
            expect(page).to have_selector(selector, text:)
          end
        end
      end
    end

    context "when headers are not present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "topical-event-with-about-page").tap do |item|
          item["details"]["about"].delete("headers")
        end
      end

      it "doesn't have a contents list" do
        expect(page).not_to have_selector(".contents-list.contents-list-dashed")
      end
    end
  end
end
