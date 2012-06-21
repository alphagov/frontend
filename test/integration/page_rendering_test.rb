# encoding: utf-8
require 'integration_test_helper'

class PageRenderingTest < ActionDispatch::IntegrationTest
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

  test "returns 503 if backend times out" do
    uri = "#{GdsApi::TestHelpers::Publisher::PUBLISHER_ENDPOINT}/publications/my-item.json"
    stub_request(:get, uri).to_raise(GdsApi::TimedOutException)
    visit "/my-item"
    assert page.status_code == 503
  end

  test "returns 503 if backend unavailable" do
    uri = "#{GdsApi::TestHelpers::Publisher::PUBLISHER_ENDPOINT}/publications/my-item.json"
    stub_request(:get, uri).to_raise(GdsApi::EndpointNotFound)
    visit "/my-item"
    assert page.status_code == 503
  end

  test "programme request" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance"
    assert page.status_code == 200
  end

  test "viewing a licence page" do
    setup_api_responses('licence-generic')
    visit "/licence-generic"
    assert page.status_code == 200
    assert page.has_content?("Licence overview copy"), %(expected there to be content Licence overview copy in #{page.text.inspect})
    assert page.has_no_content?("--------") # Markdown should be rendered, not output
  end

  test "viewing a business support page" do
    setup_api_responses("business-support-basic")
    visit "/business-support-basic"
    assert page.status_code == 200
    assert page.has_content? "Basic Business Support Item"
    assert page.has_content? "100"
    assert page.has_content? "5000"
    assert page.has_content? "Description"
  end

  test "guide request" do
    setup_api_responses("find-job")
    visit "/find-job"
    assert page.status_code == 200
    assert URI.parse(page.current_url).path == "/find-job/introduction"

    details = publisher_api_response('find-job')
    details['parts'].each do |part|
      visit "/find-job/#{part['slug']}"
      assert page.status_code == 200
    end
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
    assert_equal 200, page.status_code
  end
end

