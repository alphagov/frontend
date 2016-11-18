require "test_helper"

class GuideControllerTest < ActionController::TestCase
  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  context "GET show" do
    setup do
      @artefact = artefact_for_slug('data-protection')
      @artefact["format"] = "guide"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('data-protection', @artefact)
      end

      should "set the cache expiry headers" do
        get :show, slug: "data-protection"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "data-protection", format: 'json'

        assert_redirected_to "/api/data-protection.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("data-protection", 3, @artefact)
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "data-protection", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end

    context "guide without parts" do
      should "return a 404" do
        content_api_and_content_store_have_page(
          "disability-living-allowance-guide",
          "title" => "Disability Living Allowance",
          "format" => "guide",
          "details" => {
            "parts" => [],
            "overview" => ""
          })
        get :show, slug: "disability-living-allowance-guide"
        assert_equal '404', response.code
      end

      should "return 404 if part requested" do
        content_api_and_content_store_have_page(
          "a-slug",
          'web_url' => 'http://example.org/a-slug',
          'format' => 'guide',
          "details" => {
            'parts' => []
          })

        @controller.expects(:render).with(has_entry(status: 404))
        get :show, slug: "a-slug", part: "information"
      end
    end

    should "should redirect to base url if bad part requested of multi-part guide" do
      content_api_and_content_store_have_page(
        "a-slug",
        'web_url' => 'http://example.org/a-slug',
        'format' => 'guide',
        "details" => {
          'parts' => [
            {
              'title' => 'first',
              'slug' => 'first',
            }
          ]
        })
      get :show, slug: "a-slug", part: "information"
      assert_response :redirect
      assert_redirected_to '/a-slug'
    end

    should "should return print view" do
      content_api_and_content_store_have_page("a-slug", 'format' => 'guide')

      prevent_implicit_rendering
      @controller.expects(:render).with(:show, layout: "application.print")
      get :show, slug: "a-slug", variant: :print
      assert_equal [:print], @request.variant
    end
  end
end
