RSpec.describe "Document Collection" do
  it_behaves_like "it has meta tags", "document_collection", "document_collection"

  context "when visiting a document collection" do
    let(:content_item) { GovukSchemas::Example.find(:document_collection, example_name: "document_collection") }
    let(:base_path) { content_item["base_path"] }

    before { stub_content_store_has_item(base_path, content_item) }

    it "displays the title" do
      visit base_path

      expect(page).to have_title("National standards for driving and riding")
    end

    it "includes the description" do
      visit base_path

      expect(page).to have_text("The standards set out what it takes to be a safe and responsible driver and rider and provide training to drivers and riders.")
    end

    it "renders metadata and document footer" do
      visit base_path

      within("[class*='metadata-column']") do
        expect(page).to have_text("Driver and Vehicle Standards Agency")
        expect(page).to have_text("Published 29 February 2016")
      end

      expect(page).to have_selector(".gem-c-published-dates", text: "Published 29 February 2016")
    end

    context "when a body is provided" do
      let(:content_item) { GovukSchemas::Example.find(:document_collection, example_name: "document_collection_with_body") }

      it "renders the provided body" do
        visit base_path

        expect(page).to have_text("Each regime page provides a current list of asset freeze targets designated by the United Nations")
      end
    end

    it "renders a contents list, with one list item per document collection group" do
      visit base_path

      expect(page).to have_selector(".gem-c-contents-list", text: "Contents")

      expect(page).to have_selector(".gem-c-contents-list__list-item", count: 6)

      content_item["details"]["collection_groups"].each do |group|
        expect(page).to have_selector("nav a", text: group["title"])
      end
    end

    context "when a document collection group is empty" do
      let(:content_item) do
        GovukSchemas::Example.find(:document_collection, example_name: "document_collection").tap do |item|
          item["details"]["collection_groups"] << { "title" => "Empty Group", "documents" => [] }
        end
      end

      it "does not present the empty group in the contents list" do
        visit base_path

        expect(page).to have_selector(".gem-c-contents-list__list-item", count: 6)

        expect(page).not_to have_selector("nav a", text: "Empty Group")
      end
    end

    context "when all document collection groups are empty" do
      context "when no headers are supplied" do
        let(:content_item) do
          GovukSchemas::Example.find(:document_collection, example_name: "document_collection").tap do |item|
            item["details"]["headers"] = []

            item["details"]["collection_groups"] = [
              {
                "body" => "<div class=\"empty group\">\n</div>",
                "documents" => [],
                "title" => "Empty Group",
              },
            ]
          end
        end

        it "does not render a contents list" do
          visit base_path

          expect(page).not_to have_selector(".gem-c-contents-list")
        end
      end

      context "when h2 headers are supplied" do
        let(:content_item) do
          GovukSchemas::Example.find(:document_collection, example_name: "document_collection").tap do |item|
            item["details"]["headers"] = [
              { "id" => "one", "level" => 2, "text" => "One" },
              { "id" => "two", "level" => 2, "text" => "Two" },
              { "id" => "three", "level" => 2, "text" => "Three" },
            ]

            item["details"]["collection_groups"] = [
              {
                "body" => "<div class=\"empty group\">\n</div>",
                "documents" => [],
                "title" => "Empty Group",
              },
            ]
          end
        end

        it "renders a contents list" do
          visit base_path

          expect(page).to have_selector(".gem-c-contents-list")
        end
      end
    end

    it "renders each collection group" do
      visit base_path

      content_item["details"]["collection_groups"].each do |group|
        expect(page).to have_selector(".govuk-heading-m.govuk-\\!-font-size-27", text: group["title"])
      end

      within ".gem-c-contents-list-with-body" do
        expect(page).to have_selector(".gem-c-govspeak", count: 6)
        expect(page).to have_selector(".gem-c-document-list", count: 6)
      end
    end

    it "renders all collection documents" do
      visit base_path

      documents = content_item["links"]["documents"]

      documents.each do |doc|
        expect(page).to have_selector(".gem-c-document-list__item-title", text: doc["title"])
      end

      expect(page).to have_selector(".gem-c-document-list .gem-c-document-list__item", count: documents.count)

      document_lists = page.all(".gem-c-document-list")

      within document_lists[0] do
        list_items = page.all(".gem-c-document-list__item")
        within list_items[0] do
          expect(page).to have_text("16 March 2007")
          expect(page).to have_selector('[datetime="2007-03-16T15:00:02+00:00"]')
          expect(page).to have_text("Guidance")
        end
      end
    end

    context "with a withdrawn collection" do
      let(:content_item) { GovukSchemas::Example.find(:document_collection, example_name: "document_collection_withdrawn") }

      it "displays the withdrawn title" do
        visit base_path

        expect(page).to have_selector("title", text: "[Withdrawn]", visible: :hidden)
      end

      it "displays the withdrawn notice" do
        visit base_path

        within ".gem-c-notice" do
          expect(page).to have_text("This collection was withdrawn"), "is withdrawn"
          expect(page).to have_text("This information is now out of date.")
          expect(page).to have_selector("time[datetime='#{content_item['withdrawn_notice']['withdrawn_at']}']")
        end
      end
    end

    context "with a historically political collection" do
      let(:content_item) { GovukSchemas::Example.find(:document_collection, example_name: "document_collection_political") }

      it "shows the historical/political banner" do
        visit base_path

        within ".govuk-notification-banner__content" do
          expect(page).to have_text("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
        end
      end
    end
  end
end
