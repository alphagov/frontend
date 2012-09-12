require 'integration_test_helper'

class LicenceLookupTest < ActionDispatch::IntegrationTest

  setup do
    setup_api_responses("licence-to-kill")
  end

  context "when visiting the licence without specifying a location" do
    should "display the page content" do
      visit '/licence-to-kill'

      assert page.has_content? "Licence to kill"
      assert page.has_content? "You only live twice, Mr Bond."
    end
  end

  context "when visiting the licence with a postcode" do
    should "redirect to the appropriate authority slug" do
      visit '/licence-to-kill'

      fill_in 'postcode', :with => "SW1A 1AA"
      click_on 'Find'

      assert_equal "/licence-to-kill/westminster", current_url
    end
  end

end
