# encoding: UTF-8

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

  context "custom business browse page" do
    should "render the popular pages and find out more navigations" do
      content_api_has_section('business')
      content_api_has_subsections('business', ['monkeybusiness'])

      visit '/business'
      assert_equal 200,  page.status_code

      within('nav.popular') do
        assert page.find('h1', :text => 'Popular pages')
        assert page.find('h2', :text => 'Trade tariff')
      end
      within('nav.find-out-more') do
        assert page.find('h1', :text => 'Find out more about…')
        assert page.find('h2', :text => 'Monkeybusiness')
      end
    end
  end

  context "a browse page for a section" do
    should "show a standard section header and sub category list" do
      content_api_has_section('driving')
      content_api_has_subsections('driving', ['Roads'])

      visit '/browse/driving'
      assert_equal 200, page.status_code

      assert_raises Capybara::ElementNotFound do
        page.find('nav.popular')
        page.find('nav.find-out-more')
      end

      within('.page-header') do
        assert page.find('h1', :text => 'Driving')
      end

      within('.browse-container .sub-categories') do
        assert page.find('h2', :text => 'Roads')
      end
    end
  end
end
