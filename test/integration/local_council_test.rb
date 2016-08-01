require 'integration_test_helper'
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/local_links_manager'
class LocalCouncilTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LocalLinksManager

  context "when visiting the local transaction with a valid postcode" do
    context "for single local authority" do
      setup do
        mapit_has_a_postcode_and_areas("SW1A 1AA", [51.5010096, -0.1415870], [
          { "ons" => "00BK", "govuk_slug" => "westminster", "name" => "Westminster City Council", "type" => "LBO" },
          { "name" => "Greater London Authority", "type" => "GLA" }
          ])
        local_links_manager_has_a_local_authority('westminster')

        visit '/find-local-council'
        fill_in 'postcode', :with => "SW1A 1AA"
        click_button('Find')
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/find-local-council/westminster", current_path
      end

      should "show a get started button which links to the interaction" do
        assert page.has_content?("Something something something is a district council")
        assert page.has_content?("Westminster")
        assert page.has_link?("http://westminster.example.com", :href => "http://westminster.example.com")
      end
    end

    context "for district local authority within county" do
      setup do
        mapit_has_a_postcode_and_areas("HP20 1UG", [51.5010096, -0.1415870], [
          {
            "ons" => "00BK",
            "govuk_slug" => "aylesbury",
            "name" => "Aylesbury District",
            "type" => "DIS"
          },
          {
            "ons" => "00",
            "govuk_slug" => "buckinghamshire",
            "name" => "Buckinghamshire County",
            "type" => "CTY"
          }
        ])

        local_links_manager_has_a_district_and_county_local_authority('aylesbury', 'buckinghamshire')

        visit '/find-local-council'
        fill_in 'postcode', :with => "HP20 1UG"
        click_button('Find')
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/find-local-council/aylesbury", current_path
      end

      should "show a get started button which links to the interaction" do
        binding.pry
        assert page.has_content?("Your postcode is in a county council and a district council")
        within('.county_result') do
          assert page.has_content?("Buckinghamshire")
          assert page.has_content?("County councils are responsible for services like:")
          assert page.has_link?("http://buckinghamshire.example.com", :href => "http://buckinghamshire.example.com")
        end

        within('.district_result') do
          assert page.has_content?("Aylesbury")
          assert page.has_content?("District councils are responsible for services like:")
          assert page.has_link?("http://aylesbury.example.com", :href => "http://aylesbury.example.com")
        end
      end
    end
  end
end
