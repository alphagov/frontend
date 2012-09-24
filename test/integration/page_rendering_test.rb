require_relative '../integration_test_helper'

class PageRenderingTest < ActionDispatch::IntegrationTest

  test "returns 503 if backend times out" do
    uri = "#{GdsApi::TestHelpers::Publisher::PUBLISHER_ENDPOINT}/publications/my-item.json"
    stub_request(:get, uri).to_raise(GdsApi::TimedOutException)
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  test "returns 503 if backend unavailable" do
    uri = "#{GdsApi::TestHelpers::Publisher::PUBLISHER_ENDPOINT}/publications/my-item.json"
    stub_request(:get, uri).to_raise(GdsApi::EndpointNotFound)
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  test "quick_answer request" do
    setup_api_responses('vat-rates')
    visit "/vat-rates"
    assert_equal 200, page.status_code
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "programme request" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance"
    assert_equal 200, page.status_code
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "completed transaction request" do
    setup_api_responses('done/completed-transaction-test')
    visit "/done/completed-transaction-test"
    assert_equal 200, page.status_code
  end

  test "viewing a licence page" do
    setup_api_responses('licence-generic')
    visit "/licence-generic"
    assert_equal 200, page.status_code
    assert page.has_content?("Licence overview copy"), %(expected there to be content Licence overview copy in #{page.text.inspect})
    assert page.has_no_content?("--------") # Markdown should be rendered, not output
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "viewing a business support page" do
    setup_api_responses("business-support-basic")
    visit "/business-support-basic"
    assert_equal 200, page.status_code
    assert page.has_content? "Basic Business Support Item"
    assert page.has_content? "100"
    assert page.has_content? "5000"
    assert page.has_content? "Description"
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "guide request" do
    setup_api_responses("find-job")
    visit "/find-job"
    assert_equal 200, page.status_code
    assert URI.parse(page.current_url).path == "/find-job/introduction"
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")

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
    assert_equal 404, page.status_code

    visit "/refresh.gif"
    assert_equal 404, page.status_code

    visit "/pagerror.gif"
    assert_equal 404, page.status_code
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

  test "rendering video nav element in a guide" do
    setup_api_responses("ride-a-motorcycle-or-moped")

    visit "/ride-a-motorcycle-or-moped"

    assert page.has_css?("img[src='https://img.youtube.com/vi/iD941H0j1Z0/1.jpg']")
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

  test "rendering a programme edition's 'further information' page should keep the query string intact" do
    Capybara.current_driver = Capybara.javascript_driver

    setup_api_responses("married-couples-allowance", {edition: 5})

    visit "/married-couples-allowance/further-information?edition=5"

    assert page.has_content? "Overview"

    within ".page-navigation" do
      click_link "Overview"
    end

    assert_equal 200, page.status_code
    assert_equal "/married-couples-allowance/overview?edition=5", current_url[/\/(?!.*\.).*/]
  end

  test "viewing a video answer page" do
    setup_api_responses('test-video')
    visit "/test-video"
    assert_equal 200, page.status_code
    within '#content' do
      assert page.has_content?("This is the video summary")
      assert page.has_selector?("figure#video a[href='http://www.youtube.com/watch?v=fLreo24WYeQ']")
      assert page.has_content?("Video description")
      assert page.has_no_content?("------") # Markdown should be rendered, not output
    end
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end
end
