require 'integration_test_helper'

class HomepageTest < ActionDispatch::IntegrationTest
  should "render the homepage" do
    visit "/"
    assert_equal 200, page.status_code
    assert_equal "Welcome to GOV.UK", page.title
  end

  should "render an EU referendum banner before 3:45pm May 26" do
    travel_to Time.zone.parse('May 26 2016 15:44:00 BST') do
      visit "/"
      assert page.has_selector?('#homepage-promo-banner', text: 'EU referendum')
    end
  end

  should "not render an EU referendum banner after 3:45pm May 26" do
    travel_to Time.zone.parse('May 26 2016 15:46:00 BST') do
      visit "/"
      refute page.has_selector?('#homepage-promo-banner')
    end
  end
end
