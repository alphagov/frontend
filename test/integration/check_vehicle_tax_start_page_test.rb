require_relative '../integration_test_helper'

class CheckVehicleTaxPageTest < ActionDispatch::IntegrationTest
  context "rendering the check-vehicle-tax page" do

    should "render the check-vehicle-tax start page correctly" do

      setup_api_responses('check-vehicle-tax')
      visit "/check-vehicle-tax"

      assert_equal 200, page.status_code

      within '.start-header', :visible => :all do
        assert page.has_selector?(".title", :text => "Check if a vehicle is taxed")
      end

      within '.top-tasks' do
        assert page.has_link?("Renew a tax disc", :href => "/tax-disc")
        assert page.has_link?("Make a SORN declaration", :href => "/register-sorn-statutory-off-road-notification")
        assert page.has_link?("Report an untaxed vehicle", :href => "/report-untaxed-vehicle")
      end

      within ".eligibility-check" do
        assert page.has_selector?("h1", :text => "Check using the new service")
        assert page.has_link?("what this means for you", :href => "/help/beta")
        assert page.has_selector?("form.get-started[action='https://www.vehicleenquiry.service.gov.uk'][method=POST]")
      end

      within ".secondary-apply" do
        assert page.has_selector?("h1", :text => "Check using the original service")
        assert page.has_selector?(".destination", :text => "Check on the DVLA website:")
        assert page.has_selector?("form[action='https://www.taxdisc.direct.gov.uk/'][method=POST]")
      end

      within ".help-and-related-links" do
        assert page.has_selector?("h1", :text => "Help with tax discs")
        assert page.has_link?("Contact DVLA for questions about car tax", :href => "/contact-the-dvla")
      end

      within ".related-links" do
        assert page.has_selector?("h1", :text => "Tax discs, car tax and SORN")
        assert page.has_link?("Car tax: get a tax disc for your vehicle", :href => "/tax-disc")
        assert page.has_link?("Make a SORN (Statutory Off Road Notification)", :href => "/register-sorn-statutory-off-road-notification")
        assert page.has_link?("Report an untaxed vehicle", :href => "/report-untaxed-vehicle")
        assert page.has_link?("Vehicles exempt from vehicle tax", :href => "/vehicle-exempt-from-car-tax")
      end
    end
  end
end
