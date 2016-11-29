require "integration_test_helper"

class VideoTest < ActionDispatch::IntegrationTest
  should "render an video page" do
    setup_api_responses('test-video')
    visit "/test-video"

    assert_equal 200, page.status_code

    within 'head', visible: :all do
      assert page.has_selector?("title", text: "This is the video summary - GOV.UK", visible: :all)
    end

    within '#content' do
      assert page.has_content?("This is the video summary")
      assert page.has_selector?("figure#video a[href='https://www.youtube.com/watch?v=fLreo24WYeQ']")
      assert page.has_selector?("figure#video a[href='https://www.example.org/test.xml']", visible: :all)
      assert page.has_content?("Video description")

      within '.article-container' do
        assert page.has_selector?(".modified-date", text: "Last updated: 2 October 2012")
      end
    end

    assert_breadcrumb_rendered
    assert_related_items_rendered
  end

  should "render a video page edition in preview" do
    artefact = content_api_response("test-video")
    content_api_and_content_store_have_unpublished_page("test-video", 5, artefact)

    visit "/test-video?edition=5"

    assert_equal 200, page.status_code

    within '#content' do
      within 'header' do
        assert page.has_content?("This is the video summary")
      end
    end

    assert_current_url "/test-video?edition=5"
  end

  should "render a video in Welsh correctly" do
    # Note, this is using an English piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('test-video')
    artefact["details"]["language"] = "cy"
    content_api_and_content_store_have_page('test-video', artefact)

    visit "/test-video"

    assert_equal 200, page.status_code

    within '#content' do
      within 'header' do
        assert page.has_content?("This is the video summary")
      end

      within '.article-container' do
        assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 2 Hydref 2012")
      end
    end # within #content
  end

  context "when previously a format with parts" do
    should "reroute to the base slug if requested with part route" do
      setup_api_responses('test-video')

      visit "/test-video/old-part-route"
      assert_current_url "/test-video"
    end
  end
end
