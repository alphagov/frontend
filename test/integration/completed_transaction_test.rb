# encoding: utf-8
require 'integration_test_helper'

class CompletedTransactionTest < ActionDispatch::IntegrationTest
  setup do
    @payload = {
      base_path: "/done/no-promotion",
      schema_name: "completed_transaction",
      document_type: 'completed_transaction',
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
