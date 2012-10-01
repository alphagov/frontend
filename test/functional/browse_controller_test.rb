require_relative "../test_helper"

class BrowseControllerTest < ActionController::TestCase
  def api_returns_404_for(url)
    body = {
      "_response_info" => {
        "status" => "not found"
      }
    }
    stub_request(:get, url).to_return(:status => 404, :body => body.to_json, :headers => {})
  end

  context "GET index" do
    should "list all categories" do
      content_api_has_root_sections(["crime-and-justice"])
      get :index
      url = "http://www.test.gov.uk/browse/crime-and-justice"
      assert_select "ul h2 a", "Crime and justice"
      assert_select "ul h2 a[href=#{url}]"
    end
  end

  context "GET section" do
    should "list the sub sections" do
      content_api_has_section("crime-and-justice")
      content_api_has_subsections("crime-and-justice", ["alpha"])
      get :section, section: "crime-and-justice"

      assert_select "h1", "Crime and justice"
      assert_select "ul h2 a", "Alpha"
    end

    should "404 if the section does not exist" do
      api_returns_404_for("https://contentapi.test.alphagov.co.uk/tags/banana.json")
      api_returns_404_for("https://contentapi.test.alphagov.co.uk/tags.json?parent_id=banana&type=section")

      get :section, section: "banana"
      assert_response 404
    end
  end

  context "GET sub_section" do
    should "list the content in the sub section" do
      content_api_has_section("crime-and-justice/judges", "crime-and-justice")
      content_api_has_artefacts_in_a_section("crime-and-justice/judges", ["judge-dredd"])

      get :sub_section, section: "crime-and-justice", sub_section: "judges"

      assert_select "h1", "Crime and justice"
      assert_select "h2", "Judges"
      assert_select "li h3 a", "Judge dredd"
    end

    should "404 if the section does not exist" do
      api_returns_404_for("https://contentapi.test.alphagov.co.uk/tags/crime-and-justice%2Ffrume.json")
      api_returns_404_for("https://contentapi.test.alphagov.co.uk/tags/crime-and-justice.json")

      get :sub_section, section: "crime-and-justice", sub_section: "frume"
      assert_response 404
    end

    should "404 if the sub section does not exist" do
      content_api_has_section("crime-and-justice")
      api_returns_404_for("https://contentapi.test.alphagov.co.uk/tags/crime-and-justice%2Ffrume.json")
      get :sub_section, section: "crime-and-justice", sub_section: "frume"
      assert_response 404
    end
  end
end
