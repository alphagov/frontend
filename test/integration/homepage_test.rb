require 'integration_test_helper'

class HomepageTest < ActionDispatch::IntegrationTest
  should "render the homepage" do
    visit "/"
    assert_equal 200, page.status_code
    assert_equal "Welcome to GOV.UK", page.title
  end

  should "not render breadcrumbs" do
    visit "/"
    assert_nil page.body.match(/govuk-breadcrumbs/)
  end
end
