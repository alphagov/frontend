require_relative '../test_helper'

class ApplicationControllerTest < ActionController::TestCase
  context "creating content API client" do
    setup do
      Plek.any_instance.stubs(:website_root).returns("https://www.gov.uk")
    end

    should "create an instance using plek to find endpoint" do
      Plek.any_instance.stubs(:find).with('contentapi').returns("https://contentapi.foo.com")
      GdsApi::ContentApi.expects(:new).with("https://contentapi.foo.com", anything()).returns(:an_api_client)

      assert_equal :an_api_client, @controller.send(:content_api)
    end

    should "create an instance including website_root by default" do
      Plek.any_instance.expects(:website_root).returns("https://www.foo.gov.uk")
      GdsApi::ContentApi.expects(:new).with(anything(), CONTENT_API_CREDENTIALS.merge(:web_urls_relative_to => "https://www.foo.gov.uk")).returns(:an_api_client)

      assert_equal :an_api_client, @controller.send(:content_api)
    end

    should "not set website_root for atom requests" do
      @request.format = :atom
      GdsApi::ContentApi.expects(:new).with(anything(), CONTENT_API_CREDENTIALS).returns(:an_api_client)

      assert_equal :an_api_client, @controller.send(:content_api)
    end
  end
end
