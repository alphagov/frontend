require 'test_helper'

class RootControllerTest < ActionController::TestCase

  def setup_this_answer
    content_api_has_an_artefact("c-slug", {
      'slug' => 'c-slug',
      'format' => 'answer',
      'details' => {
        'name' => 'THIS',
        'parts' => [
          {'slug' => 'a', 'name' => 'AA'},
          {'slug' => 'b', 'name' => 'BB'}
        ]
      }
    })
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  test "should return a 404 if asked for a guide without parts" do
    content_api_has_an_artefact("disability-living-allowance-guide", {
      "title" => "Disability Living Allowance",
      "format" => "guide",
      "details" => {
        "parts" => [],
        "alternative_title" => "",
        "overview" => ""
      }
    })
    get :publication, :slug => "disability-living-allowance-guide"
    assert_equal '404', response.code
  end

  test "should 406 when asked for unrecognised format" do
    content_api_has_an_artefact("a-slug")

    get :publication, :slug => 'a-slug', :format => '123'
    assert_equal '406', response.code
  end

  test "should return a 404 if slug isn't URL friendly" do
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "a complicated slug & one that's not \"url safe\""
  end

  test "should choose template based on type of publication" do
    content_api_has_an_artefact("a-slug", {'format' => 'answer'})
    prevent_implicit_rendering
    @controller.expects(:render).with("answer")
    get :publication, :slug => "a-slug"
  end

  test "further information tab should appear for programmes that have it" do
    content_api_has_an_artefact("zippy", {'slug' => 'zippy', 'format' => 'programme', "web_url" => "http://example.org/slug","details" => {'parts' => [
            {'slug' => 'a', 'name' => 'AA'},
            {'slug' => 'further-information', 'name' => 'BB'}
          ]}})
    get :publication, :slug => "zippy"
    assert @response.body.include? "further-information"
  end

  test "further information tab should not appear for programmes that don't have it" do
    content_api_has_an_artefact("george")
    get :publication, :slug => "george"
    assert !@response.body.include?("further-information")
  end

  test "should pass edition parameter on to api to provide preview" do
    edition_id = '123'
    slug = 'c-slug'
    # stub_edition_request(slug, edition_id)
    content_api_has_unpublished_artefact(slug, edition_id)

    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, :slug => "c-slug", :edition => edition_id
  end

  test "should return video view when asked if guide has video" do
    content_api_has_an_artefact("a-slug", {'format' => 'guide', 'details' => {'video_url' => 'bob', 'parts' => [
        {'title' => 'Part 1', 'slug' => 'part-1', 'body' => 'Part 1 I am'}]}})

    prevent_implicit_rendering
    @controller.expects(:render).with("guide", layout: "application.html.erb")
    get :publication, :slug => "a-slug", :format => "video"
    assert_equal "video", @request.format
  end

  test "should not throw an error when an invalid video url is specified" do
    content_api_has_an_artefact("a-slug", {
      "web_url" => "http://example.org/a-slug",
      "details" => {
        'slug' => 'a-slug', 'video_url' => 'bob', 'updated_at' => 1.hour.ago, 'parts' => [
        {'title' => 'Part 1', 'slug' => 'part-1', 'body' => 'Part 1 I am'}]      },
      'format' => 'guide'
    })

    get :publication, :slug => "a-slug"
    get :publication, :slug => "a-slug", :format => "video"
  end

  test "should return print view" do
    content_api_has_an_artefact("a-slug")

    prevent_implicit_rendering
    @controller.expects(:render).with("guide")
    get :publication, :slug => "a-slug", :format => "print"
    # assert_template 'guide'
    assert_equal "print", @request.format
  end

  test "should return 404 if video requested but guide has no video" do
    content_api_has_an_artefact("a-slug")

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "a-slug", :format => "video"
  end

  test "should return 404 if part requested but publication has no parts" do
    content_api_has_an_artefact("a-slug", {'format' => 'answer'})

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "a-slug", :part => "information"
  end

  test "should 404 if bad part requested of multi-part guide" do
    content_api_has_an_artefact("a-slug", {
      'web_url' => 'http://example.org/a-slug', 'format' => 'guide', "details" => {'parts' => [{'title' => 'first', 'slug' => 'first'}]}
    })
    prevent_implicit_rendering
    get :publication, :slug => "a-slug", :part => "information"
    assert_response :not_found
  end

  test "should not redirect to first part URL if request is for JSON" do
    content_api_has_an_artefact("a-slug")
    prevent_implicit_rendering
    get :publication, slug: "a-slug", format: 'json'
    assert_response :success
  end

  test "should assign edition to template if it's not blank and a number" do
    edition_id = '23'
    slug = 'a-slug'

    content_api_has_unpublished_artefact(slug, edition_id)

    prevent_implicit_rendering
    get :publication, :slug => "a-slug", :edition => edition_id
    assigns[:edition] = edition_id
  end

  test "should not pass edition parameter on to api if it's blank" do
    edition_id = ''
    content_api_has_an_artefact("a-slug")

    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, :slug => "a-slug",:edition => edition_id
  end

  test "should pass specific and general variables to template" do
    content_api_has_an_artefact("c-slug", {"format" => "answer", "details" => {'name' => 'THIS'}})

    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug"
    assert_equal "THIS", assigns["publication"].name
    assert_equal "THIS", assigns["answer"].name
  end

  test "Should redirect to transaction if no geo header" do
    content_api_has_an_artefact("c-slug")

    request.env.delete("HTTP_X_GOVGEO_STACK")
    get :publication, :slug => "c-slug"
  end

  context "setting up slimmer artefact details" do
    should "expose artefact details in header" do
      # TODO: remove explicit setting of top-level format once gds-api-adapters with updated
      # factory methods is being used.
      artefact_data = artefact_for_slug_in_a_section("slug", "root-section-title")
      artefact_data["format"] = "guide"
      content_api_has_an_artefact("slug", artefact_data)

      @controller.stubs(:render)

      get :publication, :slug => "slug"

      assert_equal "guide", @response.headers["X-Slimmer-Format"]
    end

    should "set the artefact in the header" do
      artefact_data = artefact_for_slug('slug')
      content_api_has_an_artefact("slug")
      @controller.stubs(:render)

      get :publication, :slug => "slug"

      assert_equal JSON.dump(artefact_data), @response.headers["X-Slimmer-Artefact"]
    end
  end

  test "objects should have specified parts selected" do
    setup_this_answer
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug", :part => "b"
    assert_equal "BB", assigns["part"].name
  end
end
