require "test_helper"

class LicenceTransactionPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    LicenceTransactionPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#licence_transaction_continuation_link" do
    details = { details: { metadata: { licence_transaction_continuation_link: "https://continue-here.gov.uk" } } }
    assert_equal "https://continue-here.gov.uk", subject(details).licence_transaction_continuation_link
  end

  test "#licence_transaction_licence_identifier" do
    details = { details: { metadata: { licence_transaction_licence_identifier: "123" } } }
    assert_equal "123", subject(details).licence_transaction_licence_identifier
  end

  test "#licence_transaction_will_continue_on" do
    details = { details: { metadata: { licence_transaction_will_continue_on: "Westminster Council" } } }
    assert_equal "Westminster Council", subject(details).licence_transaction_will_continue_on
  end

  test "#body" do
    details = { details: { body: "Overview of the licence" } }
    assert_equal "Overview of the licence", subject(details).body
  end

  test "#slug" do
    assert_equal "new-licence", subject(base_path: "/find-licences/new-licence").slug
  end
end
