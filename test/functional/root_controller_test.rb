require 'test_helper'
require 'gds_api/test_helpers/mapit'

class RootControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Mapit

  def setup_this_answer
    content_api_and_content_store_have_page("c-slug", 'slug' => 'c-slug',
      'format' => 'answer',
      'details' => {
        'name' => 'THIS',
        'parts' => [
          { 'slug' => 'a', 'name' => 'AA' },
          { 'slug' => 'b', 'name' => 'BB' }
        ]
      })
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  test "should redirect requests for JSON" do
    setup_this_answer
    get :publication, slug: 'c-slug', format: 'json'
    assert_response :redirect
    assert_redirected_to "/api/c-slug.json"
  end

  test "should not redirect request for places JSON" do
    content_api_and_content_store_have_page("d-slug", 'slug' => 'c-slug',
      'format' => 'place',
      'details' => {
        'name' => 'THIS'
      })

    get :publication, slug: 'd-slug', format: 'json'
    assert_response :success
  end

  test "should return a 404 if asked for a guide without parts" do
    content_api_and_content_store_have_page("disability-living-allowance-guide", "title" => "Disability Living Allowance",
      "format" => "guide",
      "details" => {
        "parts" => [],
        "overview" => ""
      })
    get :publication, slug: "disability-living-allowance-guide"
    assert_equal '404', response.code
  end

  test "should 404 when asked for unrecognised format" do
    content_api_and_content_store_have_page("a-slug")

    get :publication, slug: 'a-slug', format: '123'
    assert_equal '404', response.code
  end

  test "should 404 when asked for an artefact that has an unsupported format" do
    artefact = artefact_for_slug("a-slug").merge("format" => "licence-finder")
    content_api_and_content_store_have_page("a-slug", artefact)

    get :publication, slug: 'a-slug'
    assert_equal '404', response.code
  end

  test "should return a cacheable 404 without calling content_api if slug isn't URL friendly" do
    get :publication, slug: "a complicated slug & one that's not \"url safe\""
    assert_equal "404", response.code
    assert_equal "max-age=600, public", response.headers["Cache-Control"]
    assert_not_requested(:get, %r{\A#{CONTENT_API_ENDPOINT}})
  end

  test "should return a 404 if content_api returns a 404 (nil)" do
    content_api_and_content_store_does_not_have_page("banana")
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(status: 404))
    get :publication, slug: "banana"
  end

  test "should return a 410 if content_api returns a 410" do
    content_api_and_content_store_have_archived_page("atlantis")
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(status: 410))
    get :publication, slug: "atlantis"
  end

  test "should choose template based on type of publication" do
    content_api_and_content_store_have_page("a-slug", 'format' => 'answer')
    prevent_implicit_rendering
    @controller.expects(:render).with("answer")
    get :publication, slug: "a-slug"
  end

  test "should choose custom template and locals for custom slug" do
    content_api_and_content_store_have_page("check-local-dentist", 'format' => 'answer')

    custom_slug_hash = {
        "check-local-dentist" => {
          template: "check-local-dentist",
          locals: {
            full_width: true
          }
        }
      }

    RootController.stubs(:custom_slugs).returns(custom_slug_hash)

    prevent_implicit_rendering
    @controller.expects(:render).with("check-local-dentist", locals: { full_width: true })
    get :publication, slug: "check-local-dentist"
  end

  test "should set expiry headers for an edition" do
    content_api_and_content_store_have_page("a-slug")

    get :publication, slug: 'a-slug'
    assert_equal "max-age=1800, public", response.headers["Cache-Control"]
  end

  test "further information tab should appear for programmes that have it" do
    content_api_and_content_store_have_page("zippy", 'slug' => 'zippy', 'format' => 'programme', "web_url" => "http://example.org/slug", "details" => { 'parts' => [
            { 'slug' => 'a', 'name' => 'AA' },
            { 'slug' => 'further-information', 'name' => 'BB', 'body' => "abc" }
          ] })
    get :publication, slug: "zippy"
    assert @response.body.include? "further-information"
  end

  test "further information tab should not appear for programmes where it is empty" do
    content_api_and_content_store_have_page("zippy", 'slug' => 'zippy', 'format' => 'programme', "web_url" => "http://example.org/slug", "details" => { 'parts' => [
            { 'slug' => 'a', 'name' => 'AA' },
            { 'slug' => 'further-information', 'name' => 'BB' }
          ] })
    get :publication, slug: "zippy"
    refute @response.body.include? "further-information"
  end

  test "further information tab should not appear for programmes that don't have it" do
    content_api_and_content_store_have_page("george")
    get :publication, slug: "george"
    assert !@response.body.include?("further-information")
  end

  test "should pass edition parameter on to api to provide preview" do
    edition_id = '123'
    slug = 'c-slug'
    # stub_edition_request(slug, edition_id)
    content_api_and_content_store_have_unpublished_page(slug, edition_id)

    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, slug: "c-slug", edition: edition_id
  end

  test "should return print view" do
    content_api_and_content_store_have_page("a-slug")

    prevent_implicit_rendering
    @controller.expects(:render).with("guide", layout: "application.print")
    get :publication, slug: "a-slug", variant: :print
    assert_equal [:print], @request.variant
  end

  test "should return 404 when print view of a non-=supported format is requested" do
    content_api_and_content_store_have_page("a-slug", artefact_for_slug("a-slug").merge("format" => "answer"))

    get :publication, slug: "a-slug", format: "print"
    assert_equal 404, response.status
  end

  test "should return 404 if part requested but publication has no parts" do
    content_api_and_content_store_have_page("a-slug",       'web_url' => 'http://example.org/a-slug', 'format' => 'guide', "details" => { 'parts' => [] })

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(status: 404))
    get :publication, slug: "a-slug", part: "information"
  end

  test "should redirect to base url if bad part requested of multi-part guide" do
    content_api_and_content_store_have_page("a-slug", 'web_url' => 'http://example.org/a-slug', 'format' => 'guide', "details" => { 'parts' => [{ 'title' => 'first', 'slug' => 'first' }] })
    prevent_implicit_rendering
    get :publication, slug: "a-slug", part: "information"
    assert_response :redirect
    assert_redirected_to '/a-slug'
  end

  test "should redirect to base url if part requested for non-parted format" do
    content_api_and_content_store_have_page("a-slug", 'web_url' => 'http://example.org/a-slug', 'format' => 'answer', "details" => { 'body' => 'An answer' })
    prevent_implicit_rendering
    get :publication, slug: "a-slug", part: "information"
    assert_response :redirect
    assert_redirected_to '/a-slug'
  end

  test "should assign edition to template if it's not blank and a number" do
    edition_id = '23'
    slug = 'a-slug'

    content_api_and_content_store_have_unpublished_page(slug, edition_id)

    prevent_implicit_rendering
    get :publication, slug: "a-slug", edition: edition_id
    assigns[:edition] = edition_id
  end

  test "should not pass edition parameter on to api if it's blank" do
    edition_id = ''
    content_api_and_content_store_have_page("a-slug")

    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, slug: "a-slug", edition: edition_id
  end

  test "Should not allow framing of transaction pages" do
    content_api_and_content_store_have_page("a-slug", 'slug' => 'a-slug',
      'web_url' => 'https://example.com/a-slug',
      'format' => 'transaction',
      'details' => { "need_to_know" => "" },
      'title' => 'A Test Transaction')

    prevent_implicit_rendering
    get :publication, slug: 'a-slug'
    assert_equal "DENY", @response.headers["X-Frame-Options"]
  end

  test "Should not allow framing of local transaction pages" do
    content_api_and_content_store_have_page("a-slug", 'slug' => 'a-slug',
      'web_url' => 'https://example.com/a-slug',
      'format' => 'local_transaction',
      'details' => { "need_to_know" => "" },
      'title' => 'A Test Transaction')

    prevent_implicit_rendering
    get :publication, slug: 'a-slug'
    assert_equal "DENY", @response.headers["X-Frame-Options"]
  end

  context "setting the locale" do
    should "set the locale to the artefact's locale" do
      artefact = artefact_for_slug('slug')
      artefact["details"]["language"] = 'pt'
      content_api_and_content_store_have_page('slug', artefact)

      I18n.expects(:locale=).with('pt')

      get :publication, slug: 'slug'
    end

    should "not set the locale if the artefact has no language" do
      artefact = artefact_for_slug('slug')
      artefact["details"].delete("language")
      content_api_and_content_store_have_page('slug', artefact)

      I18n.expects(:locale=).never

      get :publication, slug: 'slug'
    end
  end

  test "objects should have specified parts selected" do
    setup_this_answer
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, slug: "c-slug", part: "b"
    assert_equal "BB", assigns["publication"].current_part.name
  end

  test "should work with place editions" do
    content_api_and_content_store_have_page("a-slug", artefact_for_slug("a-slug").merge('format' => 'place', 'details' => {}))
    prevent_implicit_rendering
    get :publication, slug: "a-slug"
    assert_equal '200', response.code
  end

  context "loading the legacy transaction finished page" do
    context "given an artefact for 'transaction-finished' exists" do
      setup do
        @details = {
          'slug' => 'transaction-finished',
          'web_url' => 'https://www.preview.alphagov.co.uk/transaction-finished',
          'format' => 'completed_transaction'
        }
        content_api_and_content_store_have_page('transaction-finished', @details)
      end

      should "respond with success" do
        get :legacy_completed_transaction, slug: "transaction-finished"
        assert_response :success
      end

      should "load the correct details" do
        get :legacy_completed_transaction, slug: "transaction-finished"
        url = "https://www.preview.alphagov.co.uk/transaction-finished"
        assert_equal url, assigns(:publication).web_url
      end

      should "render the legacy completed transaction view" do
        get :legacy_completed_transaction, slug: "transaction-finished"
        assert_template "legacy_completed_transaction"
      end
    end
  end

  context "loading the jobsearch page" do
    context "given an artefact for 'jobsearch' exists" do
      setup do
        @details = {
          'slug' => 'jobsearch',
          'web_url' => 'https://www.preview.alphagov.co.uk/jobsearch',
          'format' => 'transaction',
          'details' => { "need_to_know" => "" },
          'title' => 'Universal Jobsearch'
        }
        content_api_and_content_store_have_page("jobsearch", @details)
      end

      should "respond with success" do
        get :jobsearch, slug: "jobsearch"
        assert_response :success
      end

      should "loads the correct details" do
        get :jobsearch, slug: "jobsearch"
        assert_equal "Universal Jobsearch", assigns(:publication).title
      end

      should "initialize a publication object" do
        get :jobsearch, slug: "jobsearch"
        assert_equal "Universal Jobsearch", assigns(:publication).title
      end

      should "set correct expiry headers" do
        get :jobsearch, slug: "jobsearch"
        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "render the jobsearch view" do
        get :jobsearch, slug: "jobsearch"
        assert_template "jobsearch"
      end
    end

    context "given a welsh version exists" do
      setup do
        @details = {
          'id' => 'https://www.gov.uk/api/chwilio-am-swydd.json',
          'web_url' => 'https://www.preview.alphagov.co.uk/chwilio-am-swydd',
          'format' => 'transaction',
          'details' => { "need_to_know" => "", "language" => "cy" },
          'title' => 'Universal Jobsearch'
        }
        content_api_and_content_store_have_page("chwilio-am-swydd", @details)
      end

      should "set the locale to welsh" do
        I18n.expects(:locale=).with("cy")
        get :jobsearch, slug: "chwilio-am-swydd"
      end
    end

    context "given an artefact does not exist" do
      setup do
        content_api_and_content_store_does_not_have_page('jobsearch')
      end

      should "respond with 404" do
        get :jobsearch, slug: "jobsearch"
        assert_response :not_found
      end
    end
  end
end
