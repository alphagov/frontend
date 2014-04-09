require_relative '../integration_test_helper'

class TaxDiscPageTest < ActionDispatch::IntegrationTest
  context "rendering the view-driving-licence page" do

    should "render the view-driving-licence start page correctly" do

      setup_api_responses('view-driving-licence')
      visit "/view-driving-licence"
      
      assert_equal 200, page.status_code

      within '.start-header', :visible => :all do
        assert page.has_selector?(".title", :text => "View your driving licence information")
      end

      within '.top-tasks' do
        assert page.has_link?("Change the address on your driving licence", :href => "/change-address-driving-licence")
        assert page.has_link?("Driving licence categories", :href => "/driving-licence-categories")
        assert page.has_link?("Driving licence codes", :href => "/driving-licence-codes")
      end

      within ".eligibility-check" do
        assert page.has_selector?("h1", :text => "View the new service")
        assert page.has_link?("what this means for you", :href => "/help/beta")
        assert page.has_selector?("form.get-started[action='https://www.viewdrivingrecord.service.gov.uk'][method=POST]")
      end

      within ".secondary-apply" do
        assert page.has_selector?("h1", :text => "View using the original service")
        assert page.has_selector?(".destination", :text => "View on the DVLA website:")
        assert page.has_selector?("form[action='https://motoring.direct.gov.uk/service/DvoConsumer.portal?_nfpb=true&_pageLabel=GDR&_nfls=false%20'][method=POST]")
      end

      within ".offline-apply" do
        assert page.has_selector?("h1", :text => "Other ways to apply")
      end

      within ".by-post" do
        assert page.has_selector?("h2", :text => "By post")
      end

      within ".help-and-related-links" do
        assert page.has_selector?("h1", :text => "Help with driving licences")
        assert page.has_link?("Contact DVLA for questions about driving licences", :href => "/contact-the-dvla")
      end

      within ".related-links" do
        assert page.has_selector?("h1", :text => "Driving licences")
        assert page.has_link?("Change the address on your driving licence", :href => "/change-address-driving-licence")
        assert page.has_link?("Driving licence categories", :href => "/driving-licence-categories")
        assert page.has_link?("Driving licence codes", :href => "/driving-licence-codes")
      end
    end
  end
end
