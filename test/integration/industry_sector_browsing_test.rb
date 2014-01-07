require 'integration_test_helper'

class IndustrySectorBrowsingTest < ActionDispatch::IntegrationTest

  should "render an industry sector tag page and list its sub-categories" do
    subcategories = [
      { slug: "oil-and-gas/wells", title: "Wells", description: "Wells, wells, wells." },
      { slug: "oil-and-gas/fields", title: "Fields", description: "Fields, fields, fields." },
      { slug: "oil-and-gas/offshore", title: "Offshore", description: "Information about offshore oil and gas." },
    ]

    content_api_has_tag("industry_sectors", { slug: "oil-and-gas", title: "Oil and Gas", description: "Guidance for the oil and gas industry" })
    content_api_has_child_tags("industry_sector", "oil-and-gas", subcategories)

    visit "/oil-and-gas"

    within "header.page-header" do
      assert page.has_content?("Oil and Gas")
    end

    within ".category-description" do
      assert page.has_content?("Guidance for the oil and gas industry")
    end

    within "ul.sub-categories" do
      within "li:nth-child(1)" do
        assert page.has_link?("Wells")
        assert page.has_content?("Wells, wells, wells.")
      end

      within "li:nth-child(2)" do
        assert page.has_link?("Fields")
        assert page.has_content?("Fields, fields, fields.")
      end

      within "li:nth-child(3)" do
        assert page.has_link?("Offshore")
        assert page.has_content?("Information about offshore oil and gas.")
      end
    end
  end

  should "render an industry sector sub-category and its artefacts" do
    artefacts = [
      "a-history-of-george-orwell",
      "guidance-on-wellington-boot-regulations",
      "wealth-in-the-oil-and-gas-sector"
    ]

    content_api_has_tag("industry_sectors", { slug: "oil-and-gas/wells", title: "Wells", description: "Wells, wells, wells." }, "oil-and-gas")
    content_api_has_artefacts_in_a_tag("industry_sector", "oil-and-gas/wells", artefacts)

    visit "/oil-and-gas/wells"

    within "header.page-header" do
      assert page.has_content?("Wells")
    end

    within "ul.content-list" do
      assert page.has_selector?("li", text: "A history of george orwell")
      assert page.has_selector?("li", text: "Guidance")
      assert page.has_selector?("li", text: "Wealth in the oil and gas sector")
    end
  end

end
