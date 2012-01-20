# encoding: utf-8
require 'integration_test_helper'

class LoadingPlacesTest < ActionDispatch::IntegrationTest
  def publisher_api_response(slug)
    json = File.read(Rails.root.join("test/fixtures/#{slug}.json"))
    JSON.parse(json)
  end

  def setup_api_responses(slug)
    artefact_info = {
      "slug" => slug,
      "section" => "transport"
    }
    publication_info = publisher_api_response(slug)
    publication_exists(publication_info)
    panopticon_has_metadata(artefact_info)
  end

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  test "requests for gifs 404" do
    visit "/crisis-loans/refresh.gif"
    assert page.status_code == 404

    visit "/refresh.gif"
    assert page.status_code == 404

    visit "/pagerror.gif"
    assert page.status_code == 404
  end

  test "rendering a print view of a programme" do
    setup_api_responses("child-tax-credit")

    visit "/child-tax-credit/print"
    assert page.has_content?("Get Child Tax Credit")
  end

  test "rendering a print view of a guide" do
    setup_api_responses("ride-a-motorcycle-or-moped")

    visit "/ride-a-motorcycle-or-moped/print"
    assert page.has_content?("Ride a motorcycle or moped")
  end

  test "rendering a video guide" do
    setup_api_responses("ride-a-motorcycle-or-moped")

    visit "/ride-a-motorcycle-or-moped/video"

    assert page.has_content?("Ride a motorcycle or moped")
    assert page.has_css?("a[href='http://www.youtube.com/watch?v=iD941H0j1Z0']")
  end

  test "rendering a help page" do
    visit "/help/accessibility"
    assert page.has_content?("I need help getting started online")
  end

  test "rendering a platform page" do
    visit "/platform/api"
    assert page.has_content?("API")
  end
end

