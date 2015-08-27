# encoding: utf-8
require 'integration_test_helper'

class CompletedTransactionRenderingTest < ActionDispatch::IntegrationTest

  context "a completed transaction edition" do
    should "hide organ donor registration promotion when presentation toggle is not present" do
      artefact = artefact_for_slug "no-organ-donation-registration-promotion"
      artefact = artefact.merge({ format: "completed_transaction" })
      content_api_has_an_artefact("no-organ-donation-registration-promotion", artefact)

      visit "/no-organ-donation-registration-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_no_text?("If you needed an organ transplant would you have one? If so please help others.")
        assert page.has_no_link?("Join")
      end
    end

    should "show organ donor registration promotion and survey heading if related presentation toggle is turned-on" do
      artefact = artefact_for_slug "shows-organ-donation-registration-promotion"
      artefact = artefact.merge({
        format: "completed_transaction",
        details: {
          presentation_toggles: { organ_donor_registration: { promote_organ_donor_registration: true, organ_donor_registration_url: '/organ-donor-registration-url' } }
        }
      })
      content_api_has_an_artefact("shows-organ-donation-registration-promotion", artefact)

      visit "/shows-organ-donation-registration-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_text?("If you needed an organ transplant would you have one? If so please help others.")
        assert page.has_link?("Join", href: "/organ-donor-registration-url")
        within 'h2.satisfaction-survey-heading' do
          assert page.has_text?("Satisfaction survey")
        end
      end
    end
  end
end
