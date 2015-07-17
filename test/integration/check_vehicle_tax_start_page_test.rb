require_relative '../integration_test_helper'

class CheckVehicleTaxPageTest < ActionDispatch::IntegrationTest
  context "rendering the check-vehicle-tax page" do

    should "render the check-vehicle-tax start page correctly" do

      setup_api_responses('check-vehicle-tax',
        deep_merge: {"details" => {"department_analytics_profile" => "UA-12345-6"}})
      visit "/check-vehicle-tax"

      assert_equal 200, page.status_code

      within '.start-header', :visible => :all do
        assert page.has_selector?(".title", :text => "Check if a vehicle is taxed")
      end

      within '.top-tasks' do
        assert page.has_link?("Renew vehicle tax", :href => "/vehicle-tax")
        assert page.has_link?("Make a SORN declaration", :href => "/register-sorn-statutory-off-road-notification")
        assert page.has_link?("Report an untaxed vehicle", :href => "/report-untaxed-vehicle")
      end

      within ".eligibility-check" do
        assert page.has_selector?("h1", :text => "Check using the new service")
        assert page.has_link?("what this means for you", :href => "/help/beta")
        assert page.has_selector?("form.get-started[action='https://www.vehicleenquiry.service.gov.uk'][method=POST]")
      end

      within ".help-and-related-links" do
        assert page.has_selector?("h1", :text => "Help with vehicle tax")
        assert page.has_link?("Contact DVLA for questions about car tax", :href => "/contact-the-dvla")
      end

      within ".related-links" do
        assert page.has_selector?("h1", :text => "Vehicle tax and SORN")
        assert page.has_link?("Renew vehicle tax", :href => "/vehicle-tax")
        assert page.has_link?("Make a SORN (Statutory Off Road Notification)", :href => "/register-sorn-statutory-off-road-notification")
        assert page.has_link?("Report an untaxed vehicle", :href => "/report-untaxed-vehicle")
        assert page.has_link?("Vehicles exempt from vehicle tax", :href => "/vehicle-exempt-from-car-tax")
      end

      assert_selector("#transaction_cross_domain_analytics", visible: :all, text: "UA-12345-6")
    end
  end
end
