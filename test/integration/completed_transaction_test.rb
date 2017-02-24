# encoding: utf-8
require 'integration_test_helper'

class CompletedTransactionTest < ActionDispatch::IntegrationTest
  setup do
    @payload = {
      base_path: "/done/no-promotion",
      schema_name: "completed_transaction",
      external_related_links: []
    }
  end

  context "a completed transaction edition" do
    should "show no promotion when there is no promotion choice" do
      content_store_has_item('/done/no-promotion', @payload)
      visit "/done/no-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_no_selector?('#organ-donor-registration-promotion')
        assert page.has_no_selector?('#register-to-vote-promotion')
      end
    end

    should "show register to vote promotion and survey heading if chosen" do
      payload = @payload.merge(base_path: "/done/shows-register-to-vote-promotion",
        details: {
          promotion: {
            category: 'register_to_vote',
            url: '/register-to-vote-url'
          }
        })
      content_store_has_item('/done/shows-register-to-vote-promotion', payload)

      visit "/done/shows-register-to-vote-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_text?("You must register to vote by 7 June if you want to take part in the EU referendum. You can register online and it only takes 5 minutes.")
        assert page.has_link?("Register", href: "/register-to-vote-url")
        within 'h2.satisfaction-survey-heading' do
          assert page.has_text?("Satisfaction survey")
        end
      end
    end
  end

  context "legacy transaction finished pages' special cases" do
    should "not show the satisfaction survey for transaction-finished" do
      payload = @payload.merge(base_path: "/done/transaction-finished")

      content_store_has_item("/done/transaction-finished", payload)

      visit "/done/transaction-finished"

      assert_not page.has_css?("h2.satisfaction-survey-heading")
    end

    should "not show the satisfaction survey for driving-transaction-finished" do
      payload = @payload.merge(base_path: "/done/driving-transaction-finished")

      content_store_has_item("/done/driving-transaction-finished", payload)

      visit "/done/driving-transaction-finished"

      assert_not page.has_css?("h2.satisfaction-survey-heading")
    end
  end
end
