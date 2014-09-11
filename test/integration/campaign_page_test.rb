require_relative '../integration_test_helper'

class CampaignPageTest < ActionDispatch::IntegrationTest
  
  should "render a campaign page correctly" do

    setup_api_responses('britain-is-great')
    visit "/britain-is-great"
    
    assert_equal 200, page.status_code

    organisation_link = page.find(".organisation a.organisation-logo-single-identity")

    assert_equal "Department for Transport", organisation_link.text
    assert_equal "http://www.example.com/government/organisations/cabinet-office", organisation_link['href']

    assert_equal "Britain is GREAT - GOV.UK", page.title
    assert_equal "Britain is GREAT", page.find("section#landing h1").text

    assert_match "http://www.example.com/media/52380a1e686c82231f000003/britain-is-great.jpg",
      page.find(".campaign-image .image-scope style").native.children.to_s

    assert_equal "Business", page.find('article.campaign h2:nth-of-type(1)').text
    assert_equal "Tourism", page.find('article.campaign h2:nth-of-type(2)').text
    assert_equal "Education", page.find('article.campaign h2:nth-of-type(3)').text


    within '.campaign-beta-label' do
      assert page.has_link?("find out what this means", :href => "/help/beta")
    end


  end

end
