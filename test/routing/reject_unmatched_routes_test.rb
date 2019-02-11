require "test_helper"

class RejectUnmatchedRoutesTest < ActionDispatch::IntegrationTest
  context "post to website root" do
    should "return a 405 response" do
      post "/"
      assert_equal 405, status
      assert_equal "/", path
    end
  end

  context "other requests that aren't matched" do
    setup do
      content_store_has_page('bernard', schema: 'answer')
    end

    should "return a 405 response" do
      post "/bernard"
      assert_equal 405, status
      assert_equal "/bernard", path
    end
  end
end
