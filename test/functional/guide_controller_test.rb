require "test_helper"

class GuideControllerTest < ActionController::TestCase
  include EducationNavigationAbTestHelper

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  context "GET show" do
    context "for live content" do
      setup do
        @content_item = content_store_has_example_item('/foo', schema: 'guide')
      end

      should "set the cache expiry headers" do
        get :show, slug: "foo"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "foo", format: 'json'

        assert_redirected_to "/api/foo.json"
      end

      should "have specified parts selected " do
        first_part = @content_item['details']['parts'][0]
        get :show, slug: "foo", part: first_part['slug']
        assert_equal first_part['title'], assigns["publication"].current_part.title
      end

      should "redirect to base url if bad part requested of multi-part guide" do
        get :show, slug: "foo", part: "non-existent-part"
        assert_response :redirect
        assert_redirected_to @content_item['base_path']
      end
    end

    context "guide without parts" do
      setup do
        content_store_has_example_item('/foo', schema: 'guide', example: 'no-part-guide')
      end

      should "return a 404" do
        get :show, slug: "foo"
        assert_equal '404', response.code
      end

      should "return 404 if part requested" do
        @controller.expects(:render).with(has_entry(status: 404))
        get :show, slug: "foo", part: "information"
      end
    end

    context "A/B testing" do
      setup do
        set_new_navigation
        content_store_has_example_item_tagged_to_taxon('/a-slug', schema: 'guide')
      end

      teardown do
        teardown_education_navigation_ab_test
      end

      should "show normal breadcrumbs by default" do
        expect_normal_navigation
        get :show, slug: "a-slug"
      end

      should "show normal breadcrumbs for the 'A' version" do
        expect_normal_navigation
        with_variant EducationNavigation: "A" do
          get :show, slug: "a-slug"
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        expect_new_navigation
        with_variant EducationNavigation: "B" do
          get :show, slug: "a-slug"
        end
      end
    end

    should "return print view" do
      content_store_has_example_item("/a-slug", schema: "guide")

      prevent_implicit_rendering
      @controller.expects(:render).with(:show, layout: "application.print")
      get :show, slug: "a-slug", variant: :print
      assert_equal [:print], @request.variant
    end
  end
end
