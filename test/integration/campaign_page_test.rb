require_relative '../integration_test_helper'

class CampaignPageTest < ActionDispatch::IntegrationTest

  setup do
    setup_api_responses('britain-is-great')
    visit "/britain-is-great"
  end


  should "render a campaign page correctly" do
    assert_equal 200, page.status_code
  end

  should "render the organisation name and crest" do
    organisation_link = page.find(".organisation a.organisation-logo-single-identity")   
    assert_equal "Cabinet Office", organisation_link.text
    assert_equal "https://www.gov.uk/government/organisations/cabinet-office", organisation_link['href']
  end

  should "render the campaign title" do
    assert_equal "Britain is GREAT", page.find("section#landing h1").text
  end

  should "render the campaign banner image" do
    assert_match "http://static.dev.gov.uk/media/52380a1e686c82231f000003/britain-is-great.jpg",
      page.find(".campaign-image .image-scope style").native.children.to_s
  end

  should "render the campaign edition body" do
    assert_equal "Business", page.find('article.campaign h2:nth-of-type(1)').text
    assert_equal "Tourism", page.find('article.campaign h2:nth-of-type(2)').text
    assert_equal "Education", page.find('article.campaign h2:nth-of-type(3)').text
  end
end
