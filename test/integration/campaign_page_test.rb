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

    assert_equal "Business", page.find('.campaign h2:nth-of-type(1)').text
    assert_equal "Tourism", page.find('.campaign h2:nth-of-type(2)').text
    assert_equal "Education", page.find('.campaign h2:nth-of-type(3)').text

    assert page.has_selector?(shared_component_selector('beta_label'))

  end

  should "render a campaign page with a custom logo" do

    setup_api_responses('floods-destroy')
    visit "/floods-destroy"

    assert_equal 200, page.status_code

    organisation_link = page.find(".organisation a.custom-logo")

    assert_equal "http://www.example.com/government/organisations/environment-agency", organisation_link['href']

    assert_equal "/frontend/campaign/custom-logos/environment-agency.png", organisation_link.find('img')["src"]
    assert_equal "Environment Agency", organisation_link.find('img')["alt"]
  end


end
