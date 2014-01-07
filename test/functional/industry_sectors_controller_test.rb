require_relative '../test_helper'

class IndustrySectorsControllerTest < ActionController::TestCase

  context "GET sector with a valid sector tag" do
    setup do
      subcategories = [
        { slug: "oil-and-gas/wells", title: "Wells" },
      ]

      content_api_has_tag("industry_sectors", { slug: "oil-and-gas", title: "Oil and Gas", description: "Guidance for the oil and gas industry" })
      content_api_has_child_tags("industry_sector", "oil-and-gas", subcategories)
    end

    should "request a tag from the Content API and assign it" do
      get :sector, sector: "oil-and-gas"

      assert_equal "Oil and Gas", assigns(:sector).title
      assert_equal "Guidance for the oil and gas industry", assigns(:sector).details.description
    end

    should "set the correct slimmer headers" do
      get :sector, sector: "oil-and-gas"

      assert_equal "industry-sector", response.headers["X-Slimmer-Format"]
    end
  end

  context "GET subcategory with a valid sector tag and subcategory" do
    setup do
      artefacts = [
        "guidance-about-wells",
      ]

      content_api_has_tag("industry_sectors", { slug: "oil-and-gas/wells", title: "Wells", description: "Things to do with wells" }, "oil-and-gas")
      content_api_has_artefacts_in_a_tag("industry_sector", "oil-and-gas/wells", artefacts)
    end

    should "request the tag from the Content API and assign it" do
      get :subcategory, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "Wells", assigns(:subcategory).title
      assert_equal "Things to do with wells", assigns(:subcategory).details.description
    end

    should "request and assign the artefacts for the tag from the Content API" do
      get :subcategory, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "Guidance about wells", assigns(:results).first.title
    end

    should "set the correct slimmer headers" do
      get :subcategory, sector: "oil-and-gas", subcategory: "wells"

      artefact = JSON.parse(response.headers["X-Slimmer-Artefact"])
      primary_tag = artefact["tags"][0]

      assert_equal "/oil-and-gas", primary_tag["content_with_tag"]["web_url"]
      assert_equal "Oil and gas", primary_tag["title"] # lowercase due to the humanisation of slug in test helpers

      assert_equal "industry-sector", response.headers["X-Slimmer-Format"]
    end
  end

end
