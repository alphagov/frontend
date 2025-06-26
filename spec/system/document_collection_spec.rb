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
  end

  # test "renders no contents list if body has no h2s and is long and collection groups are empty" do
  #   content_item = get_content_example("document_collection")

  #   content_item["details"]["body"] = <<~HTML
  #     <div class="empty group">
  #       <p>#{Faker::Lorem.characters(number: 200)}</p>
  #       <p>#{Faker::Lorem.characters(number: 200)}</p>
  #       <p>#{Faker::Lorem.characters(number: 200)}</p>
  #     </div>
  #   HTML

  #   content_item["details"]["collection_groups"] = [
  #     {
  #       "body" => "<div class=\"empty group\">\n</div>",
  #       "documents" => [],
  #       "title" => "Empty Group",
  #     },
  #   ]

  #   content_item["base_path"] += "-no-h2s"

  #   stub_content_store_has_item(content_item["base_path"], content_item.to_json)
  #   visit(content_item["base_path"])
  #   assert_not page.has_css?(".gem-c-contents-list")
  # end

  # test "renders contents list if body has h2s and collection groups are empty" do
  #   content_item = get_content_example("document_collection")

  #   content_item["details"]["body"] = <<~HTML
  #     <div class="empty group">
  #       <h2 id="one">One</h2>
  #       <p>#{Faker::Lorem.characters(number: 200)}</p>
  #       <h2 id="two">Two</h2>
  #       <p>#{Faker::Lorem.characters(number: 200)}</p>
  #       <h2 id="three">Three</h2>
  #       <p>#{Faker::Lorem.characters(number: 200)}</p>
  #     </div>
  #   HTML

  #   content_item["details"]["collection_groups"] = [
  #     {
  #       "body" => "<div class=\"empty group\">\n</div>",
  #       "documents" => [],
  #       "title" => "Empty Group",
  #     },
  #   ]

  #   content_item["base_path"] += "-h2s"

  #   stub_content_store_has_item(content_item["base_path"], content_item.to_json)
  #   visit(content_item["base_path"])
  #   assert page.has_css?(".gem-c-contents-list")
  # end

  # test "renders each collection group" do
  #   setup_and_visit_content_item("document_collection")
  #   groups = @content_item["details"]["collection_groups"]
  #   group_count = groups.count

  #   groups.each do |group|
  #     assert page.has_css?(".govuk-heading-m.govuk-\\!-font-size-27", text: group["title"])
  #   end

  #   within ".gem-c-contents-list-with-body" do
  #     assert page.has_css?(".gem-c-govspeak", count: group_count)
  #     assert page.has_css?(".gem-c-document-list", count: group_count)
  #   end
  # end

  # test "renders all collection documents" do
  #   setup_and_visit_content_item("document_collection")
  #   documents = @content_item["links"]["documents"]

  #   documents.each do |doc|
  #     assert page.has_css?(".gem-c-document-list__item-title", text: doc["title"])
  #   end

  #   assert page.has_css?(".gem-c-document-list .gem-c-document-list__item", count: documents.count)

  #   document_lists = page.all(".gem-c-document-list")

  #   within document_lists[0] do
  #     list_items = page.all(".gem-c-document-list__item")
  #     within list_items[0] do
  #       assert page.has_text?("16 March 2007"), "has properly formatted date"
  #       assert page.has_css?('[datetime="2007-03-16T15:00:02+00:00"]'), "has iso8601 datetime attribute"
  #       assert page.has_text?("Guidance"), "has formatted document_type"
  #     end
  #   end
  # end

  # test "withdrawn collection" do
  #   setup_and_visit_content_item("document_collection_withdrawn")
  #   assert page.has_css?("title", text: "[Withdrawn]", visible: false)

  #   within ".gem-c-notice" do
  #     assert page.has_text?("This collection was withdrawn"), "is withdrawn"
  #     assert page.has_text?("This information is now out of date.")
  #     assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
  #   end
  # end

  # test "historically political collection" do
  #   setup_and_visit_content_item("document_collection_political")

  #   within ".govuk-notification-banner__content" do
  #     assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
  #   end
  # end
end
