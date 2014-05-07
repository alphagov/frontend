require 'integration_test_helper'

class SpecialistSectorBrowsingTest < ActionDispatch::IntegrationTest

  should "render an specialist sector tag page and list its sub-categories" do
    subcategories = [
      { slug: "oil-and-gas/wells", title: "Wells", description: "Wells, wells, wells." },
      { slug: "oil-and-gas/fields", title: "Fields", description: "Fields, fields, fields." },
      { slug: "oil-and-gas/offshore", title: "Offshore", description: "Information about offshore oil and gas." },
    ]

    content_api_has_tag("specialist_sector", { slug: "oil-and-gas", title: "Oil and gas", description: "Guidance for the oil and gas industry" })
    content_api_has_child_tags("specialist_sector", "oil-and-gas", subcategories)

    visit "/oil-and-gas"
    assert page.has_title?("Oil and gas - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
    end

    within ".category-description" do
      assert page.has_content?("Guidance for the oil and gas industry")
    end

    within ".topics ul" do
      within "li:nth-child(1)" do
        assert page.has_link?("Wells")
      end

      within "li:nth-child(2)" do
        assert page.has_link?("Fields")
      end

      within "li:nth-child(3)" do
        assert page.has_link?("Offshore")
      end
    end
  end

  should "render an specialist sector sub-category and its artefacts" do
    artefacts = [
      "wealth-in-the-oil-and-gas-sector",
      "guidance-on-wellington-boot-regulations",
      "a-history-of-george-orwell"
    ]

    content_api_has_tag("specialist_sector", { slug: "oil-and-gas/wells", title: "Wells", description: "Wells, wells, wells." }, "oil-and-gas")
    content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/wells", artefacts)

    visit "/oil-and-gas/wells"

    assert page.has_title?("Oil and gas: Wells - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
      assert page.has_content?("Wells")
    end

    within ".index-list" do
      assert page.has_selector?("li", text: "Wealth in the oil and gas sector")
    end
  end

end
