RSpec.describe "Statistical Data Set" do
  it_behaves_like "it has meta tags", "statistical_data_set", "statistical_data_set"

  context "when visiting a statistical data set" do
    let(:content_item) { GovukSchemas::Example.find(:statistical_data_set, example_name: "statistical_data_set") }
    let(:base_path) { content_item["base_path"] }

    before { stub_content_store_has_item(base_path, content_item) }

    it "displays the title" do
      visit base_path

      expect(page).to have_title("Olympics (TSGB10)")
    end

    it "includes the description" do
      visit base_path

      expect(page).to have_text("Statistics focusing on transport data relating to the 2012 Olympic and Paralympic period, compared to the same period in the previous year.")
    end

    it "includes the body" do
      visit base_path

      expect(page).to have_text("This is not intended to be a comprehensive review of transport performance in London or Great Britain during the Games")
    end

    it "renders metadata" do
      visit base_path

      within("[class*='metadata-column']") do
        expect(page).to have_text("Department for Transport")
        expect(page).to have_text("Published 13 December 2012")
      end
    end

    it "shows the published date in the footer" do
      visit base_path

      expect(page).to have_selector(".gem-c-published-dates", text: "Published 13 December 2012")
    end
  end
  #   test "historically political statistical data set" do
  #     setup_and_visit_content_item("statistical_data_set_political")

  #     within ".govuk-notification-banner__content" do
  #       assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
  #     end
  #   end

  #   test "renders with contents list" do
  #     setup_and_visit_content_item("statistical_data_set")

  #     assert_has_contents_list([
  #       { text: "Olympics", id: "olympics" },
  #       { text: "Table TSGB1001", id: "table-tsgb1001" },
  #       { text: "Table TSGB1002", id: "table-tsgb1002" },
  #       { text: "Table TSGB1003", id: "table-tsgb1003" },
  #       { text: "Table TSGB1004", id: "table-tsgb1004" },
  #       { text: "Table TSGB1005", id: "table-tsgb1005" },
  #     ])
  #   end

  #   test "does not render with the single page notification button" do
  #     setup_and_visit_content_item("statistical_data_set")
  #     assert_not page.has_css?(".gem-c-single-page-notification-button")
  #   end
end
