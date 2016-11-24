require "test_helper"

class ProgrammeControllerTest < ActionController::TestCase
  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  context "GET show" do
    setup do
      @artefact = artefact_for_slug('reduced-earnings-allowance')
      @artefact["format"] = "programme"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('reduced-earnings-allowance', @artefact)
      end

      should "set the cache expiry headers" do
        get :show, slug: "reduced-earnings-allowance"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "reduced-earnings-allowance", format: 'json'

        assert_redirected_to "/api/reduced-earnings-allowance.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("reduced-earnings-allowance", 3, @artefact)
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "reduced-earnings-allowance", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end

    context "programme without parts" do
      should "return a 404" do
        content_api_and_content_store_have_page(
          "reduced-earnings-allowance",
          "title" => "Reduced Earnings Allowance",
          "format" => "programme",
          "details" => {
            "parts" => [],
            "overview" => ""
          })
        get :show, slug: "reduced-earnings-allowance"
        assert_equal '404', response.code
      end

      should "return 404 if part requested" do
        content_api_and_content_store_have_page(
          "a-slug",
          'web_url' => 'http://example.org/a-slug',
          'format' => 'programme',
          "details" => {
            'parts' => []
          })

        @controller.expects(:render).with(has_entry(status: 404))
        get :show, slug: "a-slug", part: "information"
      end
    end


    context "programme with parts" do
      setup do
        content_api_and_content_store_have_page(
          "a-slug",
          'web_url' => 'http://example.org/a-slug',
          'format' => 'programme',
          "details" => {
            'parts' => [
              {
                'title' => 'first',
                'slug' => 'first',
                'name' => 'First Part',
              },
              {
                'title' => 'second',
                'slug' => 'second',
                'name' => 'Second Part',
              },
            ]
          })
      end

      should "have specified parts selected " do
        get :show, slug: "a-slug", part: "first"
        assert_equal "First Part", assigns["publication"].current_part.name
      end

      context "with missing part" do
        should "redirect to base url if missing part requested of multi-part programme" do
          get :show, slug: "a-slug", part: "further-information"
          assert_response :redirect
          assert_redirected_to '/a-slug'
        end

        should "not show missing part tab" do
          get :show, slug: "a-slug"
          assert !@response.body.include?("further-information")
        end
      end
    end

    should "not show part tab when it is empty" do
      content_api_and_content_store_have_page("zippy", 'slug' => 'zippy', 'format' => 'programme', "web_url" => "http://example.org/slug", "details" => { 'parts' => [
              { 'slug' => 'a', 'name' => 'AA' },
              { 'slug' => 'further-information', 'name' => 'BB' }
            ] })
      get :show, slug: "zippy"
      refute @response.body.include? "further-information"
    end

    should "return print view" do
      content_api_and_content_store_have_page("a-slug", 'format' => 'programme')

      prevent_implicit_rendering
      @controller.expects(:render).with(:show, layout: "application.print")
      get :show, slug: "a-slug", variant: :print
      assert_equal [:print], @request.variant
    end
  end
end
