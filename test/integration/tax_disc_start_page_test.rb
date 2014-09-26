require_relative '../integration_test_helper'

class TaxDiscPageTest < ActionDispatch::IntegrationTest
  context "rendering the tax-disc page" do

    should "render the tax-disc start page correctly" do

      setup_api_responses('tax-disc')
      visit "/tax-disc"

      assert_equal 200, page.status_code

      within '.start-header', :visible => :all do
        assert page.has_selector?(".title", :text => "Renew a tax disc")
      end

      within '.top-tasks' do
        assert page.has_link?("Make a SORN declaration", :href => "/register-sorn-statutory-off-road-notification")
        assert page.has_link?("Apply for HGV vehicle tax", :href => "/apply-hgv-vehicle-licence-tax-disc-form-v85")
        assert page.has_link?("Calculate vehicle tax rates", :href => "/calculate-vehicle-tax-rates")
      end

      within ".eligibility-check" do
        assert page.has_selector?("h1", :text => "Before you start")
        assert page.has_selector?(".destination", :text => "Apply on the DVLA website:")
        assert page.has_selector?("form.get-started[action='/g']")
        assert page.has_selector?("form.get-started input[type='hidden'][name='url'][value='https://www.taxdisc.direct.gov.uk/EvlPortalApp/app/home/intro?skin=directgov']")
      end

      within ".secondary-apply" do
        assert page.has_selector?("h1", :text => "Apply using the new service")
        assert page.has_link?("what this means for you", :href => "/help/beta")
        assert page.has_selector?("form[action='/g']")
        assert page.has_selector?("form input[type='hidden'][name='url'][value='https://www.taxdisc.service.gov.uk']")
      end

      within ".offline-apply" do
        assert page.has_selector?("h1", :text => "Other ways to apply")
        assert page.has_selector?("li", :text => "0300 123 4321")
        assert page.has_selector?("li", :text => "0300 790 6201")
      end

      within ".at-post-office" do
        assert page.has_selector?("h2", :text => "At the Post Office")
          within ".application-notice" do
            assert page.has_link?("Northern Ireland", :href => "http://www.nidirect.gov.uk/insurance-and-mot-needed-to-tax-your-vehicle")
          end
      end

      within ".help-and-related-links" do
        assert page.has_selector?("h1", :text => "Help with car tax")
        assert page.has_link?("Contact DVLA for questions about car tax", :href => "/contact-the-dvla")
      end

      within ".related-links" do
        assert page.has_selector?("h1", :text => "Vehicle tax (tax disc)")
        assert page.has_link?("Make a SORN (Statutory Off Road Notification)", :href => "/register-sorn-statutory-off-road-notification")
        assert page.has_link?("Calculate vehicle tax rates", :href => "/calculate-vehicle-tax-rates")
        assert page.has_link?("Apply for HGV vehicle tax", :href => "/apply-hgv-vehicle-licence-tax-disc-form-v85")
      end
    end
  end
end
