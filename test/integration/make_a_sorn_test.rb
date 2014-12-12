require_relative '../integration_test_helper'

class TaxDiscPageTest < ActionDispatch::IntegrationTest
  context "rendering the make-a-sorn page" do

    should "render the make-a-sorn start page correctly" do

      setup_api_responses('make-a-sorn')
      visit "/make-a-sorn"

      assert_equal 200, page.status_code

      within '.start-header', :visible => :all do
        assert page.has_selector?(".title", :text => "Make a SORN")
      end

      within '.top-tasks' do
        assert page.has_link?("Renew vehicle tax", :href => "/vehicle-tax")
        assert page.has_link?("Get vehicle information from DVLA", :href => "/get-vehicle-information-from-dvla")
        assert page.has_link?("SORN (Statutory Off Road Notification)", :href => "/sorn-statutory-off-road-notification")
      end

      within ".eligibility-check" do
        assert page.has_selector?("h1", :text => "Apply using the new service")
        assert page.has_link?("what this means for you", :href => "/help/beta")
        assert page.has_selector?("form.get-started[action='https://www.sorn.service.gov.uk'][method=POST]")
      end

      within ".offline-apply" do
        assert page.has_selector?("h1", :text => "Other ways to apply")
        assert page.has_selector?("li", :text => "0300 123 4321")
        assert page.has_selector?("li", :text => "0300 790 6201")
      end

      within ".by-post" do
        assert page.has_selector?("h2", :text => "By post")
      end

      within ".help-and-related-links" do
        assert page.has_selector?("h1", :text => "Help with making a SORN")
        assert page.has_link?("Contact DVLA for questions about making a SORN", :href => "/contact-the-dvla")
      end

      within ".related-links" do
        assert page.has_link?("Renew vehicle tax", :href => "/vehicle-tax")
        assert page.has_link?("Get vehicle information from DVLA", :href => "/get-vehicle-information-from-dvla")
        assert page.has_link?("SORN (Statutory Off Road Notification)", :href => "/sorn-statutory-off-road-notification")
      end
    end
  end
end
