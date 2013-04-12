require_relative '../integration_test_helper'

class BrowseTest < ActionDispatch::IntegrationTest

  context "redirecting JSON requests" do
    should "redirect browse index to the public_api" do
      get "/browse.json"
      assert_redirected_to "/api/tags.json?type=section&root_sections=true"
    end

    should "redirect browse section to the public_api" do
      get "/browse/crime-and-justice.json"
      assert_redirected_to "/api/tags.json?type=section&parent_id=crime-and-justice"
    end

    should "redirect browse subsection to the public_api" do
      get "/browse/crime-and-justice/judges.json"
      assert_redirected_to "/api/with_tag.json?tag=crime-and-justice%2Fjudges"
    end
  end
end
