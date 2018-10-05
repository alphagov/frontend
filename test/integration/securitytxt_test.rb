require 'integration_test_helper'

class SecuritytxtTest < ActionDispatch::IntegrationTest
  setup do
    content_store_has_item("/security.txt", schema: 'special_route')
  end

  should "render the security.txt plain text file" do
    visit "/security.txt"
    assert_equal 200, page.status_code
    assert_match(/Contact:/, page.body)
  end
end
