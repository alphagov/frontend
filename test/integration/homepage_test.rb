require_relative "../integration_test_helper"

class HomepageTest < ActionDispatch::IntegrationTest

  context "seeing the root sections on the homepage" do
    should "display the root sections from the content_api in alphabetical order" do
      content_api_has_root_sections([
        {
          :slug => "employing-people",
          :title => "Employing people",
          :short_description => "Includes pay, contracts and hiring",
        },
        {
          :slug => "business",
          :title => "Businesses and self-employed",
          :short_description => "Tools and guidance for businesses",
        },
        {
          :slug => "justice",
          :title => "Crime, justice and the law",
          :short_description => "Legal processes, courts and the police",
        },
      ])
      
      visit "/"

      within ".homepage-categories" do
        titles = page.all('li a').map(&:text)
        assert_equal ['Businesses and self-employed', 'Crime, justice and the law', 'Employing people'], titles

        within :xpath, ".//li[contains(., 'Business')]" do
          assert page.has_link?("Business", :href => "http://www.test.gov.uk/browse/business")
          assert page.has_content?("Tools and guidance for businesses")
        end

        within :xpath, ".//li[contains(., 'Crime, justice and the law')]" do
          assert page.has_link?("Crime, justice and the law", :href => "http://www.test.gov.uk/browse/justice")
          assert page.has_content?("Legal processes, courts and the police")
        end

        within :xpath, ".//li[contains(., 'Employing people')]" do
          assert page.has_link?("Employing people", :href => "http://www.test.gov.uk/browse/employing-people")
          assert page.has_content?("Includes pay, contracts and hiring")
        end
      end
    end
  end
end
