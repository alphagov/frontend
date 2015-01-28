require_relative '../integration_test_helper'

class PageRenderingTest < ActionDispatch::IntegrationTest

  context "backend error handling" do
    context "backend timeout" do
      setup do
        stub_request(:get, "#{Plek.current.find('contentapi')}/my-item.json").to_timeout
      end

      should "return 503 if backend times out" do
        visit "/my-item"
        assert_equal 503, page.status_code
      end
    end

    context "backend 500 error" do
      setup do
        stub_request(:get, "#{Plek.current.find('contentapi')}/my-item.json").to_return(:status => 500)
      end

      should "return 503" do
        visit "/my-item"
        assert_equal 503, page.status_code
      end
    end

    context "backend connection refused" do
      setup do
        stub_request(:get, "#{Plek.current.find('contentapi')}/my-item.json").to_raise(Errno::ECONNREFUSED)
      end

      should "return 503 if backend connection is refused" do
        visit "/my-item"
        assert_equal 503, page.status_code
      end
    end
  end

  test "completed transaction request" do
    artefact = artefact_for_slug "done/completed-transaction-test"
    artefact = artefact.merge({
      format: "completed_transaction"
    })
    content_api_has_an_artefact('done/completed-transaction-test', artefact)
    visit "/done/completed-transaction-test"
    assert_equal 200, page.status_code
  end

  test "viewing a licence page" do
    setup_api_responses('licence-generic')
    visit "/licence-generic"
    assert_equal 200, page.status_code
    assert page.has_content?("Licence overview copy"), %(expected there to be content Licence overview copy in #{page.text.inspect})
  end

  test "viewing a business support page" do
    artefact = artefact_for_slug "business-support-example"
    artefact = artefact.merge({"format" => "business_support"})
    artefact = artefact.merge(content_api_response("business-support-example"))
    content_api_has_an_artefact('business-support-example', artefact)
    visit "/business-support-example"
    assert_equal 200, page.status_code
    assert page.has_content? "Business support example"
    assert page.has_content? "Provides UK businesses with free, quick and easy access to a directory of approved finance suppliers"
    assert page.has_content? "How much you can get"
    assert_match /1 -.*?20,000,000/, page.text
    assert page.has_content? "Eligibility"
    assert page.has_content? "Will depend on the individual provider."
    assert page.has_link? "Find out more", href: "http://www.businessfinanceforyou.co.uk/finance-finder"
    assert page.has_content? "What you need to know"
    assert page.has_content? "Additional information"
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

  test "viewing a video answer page" do
    setup_api_responses('test-video')
    visit "/test-video"
    assert_equal 200, page.status_code
    within '#content' do
      assert page.has_content?("This is the video summary")
      assert page.has_selector?("figure#video a[href='https://www.youtube.com/watch?v=fLreo24WYeQ']")
      assert page.has_selector?("figure#video a[href='https://www.example.org/test.xml']", :visible => :all)
      assert page.has_content?("Video description")
    end
  end
end
