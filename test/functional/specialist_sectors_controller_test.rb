require_relative '../test_helper'

class SpecialistSectorsControllerTest < ActionController::TestCase

  context "GET sector with a valid sector tag" do
    setup do
      subcategories = [
        { slug: "oil-and-gas/wells", title: "Wells" },
      ]

      content_api_has_tag("specialist_sector", { slug: "oil-and-gas", title: "Oil and Gas", description: "Guidance for the oil and gas industry" })
      content_api_has_child_tags("specialist_sector", "oil-and-gas", subcategories)
    end

    should "request a tag from the Content API and assign it" do
      get :sector, sector: "oil-and-gas"

      assert_equal "Oil and Gas", assigns(:sector).title
      assert_equal "Guidance for the oil and gas industry", assigns(:sector).details.description
    end

    should "set the correct slimmer headers" do
      get :sector, sector: "oil-and-gas"

      assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
      assert_equal "after:.page-header", response.headers["X-Slimmer-Beta-Label"]
    end

    should "set expiry headers for 30 minutes" do
      get :sector, sector: "oil-and-gas"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  should "return a 404 status for GET sector with an invalid sector tag" do
    api_returns_404_for("/tags/specialist_sector/oil-and-gas.json")
    get :sector, sector: "oil-and-gas"

    assert_equal 404, response.status
  end

  context "GET subcategory with a valid sector tag and subcategory" do
    setup do
      artefacts = [
        "guidance-about-wells",
        "something-else-about-wells"
      ]

      content_api_has_tag("specialist_sector", { slug: "oil-and-gas/wells", title: "Wells", description: "Things to do with wells" }, "oil-and-gas")
      content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/wells", artefacts)
    end

    should "request the tag from the Content API and assign it" do
      get :subcategory, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "Wells", assigns(:subcategory).title
      assert_equal "Things to do with wells", assigns(:subcategory).details.description
    end

    should "request and assign the artefacts for the tag from the Content API" do
      get :subcategory, sector: "oil-and-gas", subcategory: "wells"

      result = assigns(:results).first
      assert_equal "Guidance about wells", result.title
    end

    should "set the correct slimmer headers" do
      get :subcategory, sector: "oil-and-gas", subcategory: "wells"

      artefact = JSON.parse(response.headers["X-Slimmer-Artefact"])
      primary_tag = artefact["tags"][0]

      assert_equal "/oil-and-gas", primary_tag["content_with_tag"]["web_url"]
      assert_equal "Oil and gas", primary_tag["title"] # lowercase due to the humanisation of slug in test helpers

      assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
      assert_equal "after:.page-header", response.headers["X-Slimmer-Beta-Label"]
    end

    should "set expiry headers for 30 minutes" do
      get :subcategory, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  should "return a 404 status for GET subcategory with an invalid subcategory tag" do
    api_returns_404_for("/tags/specialist_sector/oil-and-gas%2Fcoal.json")
    get :subcategory, sector: "oil-and-gas", subcategory: "coal"

    assert_equal 404, response.status
  end

  context "invalid slugs" do
    should "return a cacheable 404 without calling content_api if the sector slug is invalid" do
      get :sector, sector: "this & that"
      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]

      get :sector, sector: "fco\xA0" # Invalid UTF-8
      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]

      get :sector, sector: "br54ba\x9CAQ\xC4\xFD\x928owse" # Malformed UTF-8
      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]

      get :sector, sector: "\xE9\xF3(\xE9\xF3ges" # Differently Malformed UTF-8
      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]

      assert_not_requested(:get, %r{\A#{CONTENT_API_ENDPOINT}})
    end

    should "return a cacheable 404 without calling content_api if the sector subcategory slug is invalid" do
      get :subcategory, sector: "oil-and-gas", subcategory: "this & that"
      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]

      get :subcategory, sector: "oil-and-gas", subcategory: "fco\xA0" # Invalid UTF-8
      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]

      get :subcategory, sector: "oil-and-gas", subcategory: "br54ba\x9CAQ\xC4\xFD\x928owse" # Malformed UTF-8
      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]

      get :subcategory, sector: "oil-and-gas", subcategory: "\xE9\xF3(\xE9\xF3ges" # Differently Malformed UTF-8
      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]

      assert_not_requested(:get, %r{\A#{CONTENT_API_ENDPOINT}})
    end
  end

end
