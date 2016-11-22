# encoding: utf-8
require 'integration_test_helper'

class CompletedTransactionRenderingTest < ActionDispatch::IntegrationTest
  context "a completed transaction edition" do
    should "show no promotion when presentation toggle is not present" do
      artefact = artefact_for_slug "no-promotion"
      artefact = artefact.merge(format: "completed_transaction")
      content_api_and_content_store_have_page("no-promotion", artefact)

      visit "/no-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_no_selector?('#organ-donor-registration-promotion')
        assert page.has_no_selector?('#register-to-vote-promotion')
      end
    end

    should "show organ donor registration promotion and survey heading if chosen" do
      artefact = artefact_for_slug "shows-organ-donation-registration-promotion"
      artefact = artefact.merge(format: "completed_transaction",
        details: {
          presentation_toggles: {
            promotion_choice: {
              choice: 'organ_donor',
              url: '/organ-donor-registration-url'
            }
          }
        })
      content_api_and_content_store_have_page("shows-organ-donation-registration-promotion", artefact)

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

    should "show register to vote promotion and survey heading if chosen" do
      artefact = artefact_for_slug "shows-register-to-vote-promotion"
      artefact = artefact.merge(format: "completed_transaction",
        details: {
          presentation_toggles: {
            promotion_choice: {
              choice: 'register_to_vote',
              url: '/register-to-vote-url'
            }
          }
        })
      content_api_and_content_store_have_page("shows-register-to-vote-promotion", artefact)

      visit "/shows-register-to-vote-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_text?("You must register to vote by 7 June if you want to take part in the EU referendum. You can register online and it only takes 5 minutes.")
        assert page.has_link?("Register", href: "/register-to-vote-url")
        within 'h2.satisfaction-survey-heading' do
          assert page.has_text?("Satisfaction survey")
        end
      end
    end

    should "show no promotion when choice is not organ donor or register to vote" do
      artefact = artefact_for_slug "unknown-promotion"
      artefact = artefact.merge(format: "completed_transaction",
        details: {
          presentation_toggles: {
            promotion_choice: {
              choice: 'cheese_hats',
              url: '/get-free-cheese-hats-url'
            }
          }
        })
      content_api_and_content_store_have_page("unknown-promotion", artefact)

      visit "/unknown-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_no_selector?('#organ-donor-registration-promotion')
        assert page.has_no_selector?('#register-to-vote-promotion')
        assert page.has_no_link?(href: '/get-free-cheese-hats-url')
      end
    end
  end

  context "legacy transaction finished pages' special cases" do
    should "redirect transaction-finished JSON requests" do
      setup_api_responses('transaction-finished')
      get "/transaction-finished.json"
      assert_equal 301, response.code.to_i
      assert_redirected_to "/api/transaction-finished.json"
    end

    should "redirect driving-transaction-finished JSON requests" do
      setup_api_responses('driving-transaction-finished')
      get "/driving-transaction-finished.json"
      assert_equal 301, response.code.to_i
      assert_redirected_to "/api/driving-transaction-finished.json"
    end

    should "render the transaction-finished page correctly" do
      setup_api_responses('transaction-finished')
      visit "/transaction-finished"
      assert_equal 200, page.status_code
      within "#content" do
        within "header" do
          assert page.has_content?("Your transaction is finished")
        end
        within '.article-container' do
          assert page.has_content?("Please join the NHS Organ Donor Register")
          assert page.has_selector?(".button", text: "Join")
        end
      end
    end

    should "render the driving-transaction-finished page correctly" do
      setup_api_responses('driving-transaction-finished')
      visit "driving-transaction-finished"
      assert_equal 200, page.status_code
      within "#content" do
        within "header" do
          assert page.has_content?("Thank you")
        end
      end
    end
  end
end
