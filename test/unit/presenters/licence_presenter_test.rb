require "test_helper"

class LicencePresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    LicencePresenter.new(content_item.deep_stringify_keys!)
  end

  test "#introduction" do
    assert_equal 'https://continue-here.gov.uk', subject(details: { continuation_link: 'https://continue-here.gov.uk' }).continuation_link
  end

  test "#licence_identifier" do
    assert_equal '123', subject(details: { licence_identifier: '123' }).licence_identifier
  end

  test "#licence_overview" do
    assert_equal 'Overview of the licence', subject(details: { licence_overview: 'Overview of the licence' }).licence_overview
  end

  test "#licence_short_description" do
    assert_equal 'Short description', subject(details: { licence_short_description: 'Short description' }).licence_short_description
  end

  test "#will_continue_on" do
    assert_equal 'Westminster Council', subject(details: { will_continue_on: 'Westminster Council' }).will_continue_on
  end
end
