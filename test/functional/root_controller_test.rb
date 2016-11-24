require 'test_helper'
require 'gds_api/test_helpers/mapit'

class RootControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Mapit

  def setup_this_publication
    content_api_and_content_store_have_page(
      'c-slug',
      'format' => 'business_support',
      'details' => {
        'name' => 'THIS',
        'parts' => [
          { 'slug' => 'first_part', 'name' => 'First Part' },
          { 'slug' => 'second_part', 'name' => 'Second Part' }
        ]
      })
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  test "should redirect requests for JSON" do
    setup_this_publication
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
    content_api_and_content_store_have_page("a-slug", 'format' => 'business_support')
    prevent_implicit_rendering
    @controller.expects(:render).with("business_support")
    get :publication, slug: "a-slug"
  end

  test "should choose custom template and locals for custom slug" do
    content_api_and_content_store_have_page("check-local-dentist", 'format' => 'business_support')

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
    content_api_and_content_store_have_page(
      "a-slug",
      'format' => 'local_transaction',
      "web_url" => "http://example.org/slug"
    )

    get :publication, slug: 'a-slug'
    assert_equal "max-age=1800, public", response.headers["Cache-Control"]
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

  test "should return 404 when print view of a non-supported format is requested" do
    content_api_and_content_store_have_page("a-slug", artefact_for_slug("a-slug").merge("format" => "business_support"))

    get :publication, slug: "a-slug", format: "print"
    assert_equal 404, response.status
  end

  test "should redirect to base url if part requested for non-parted format" do
    content_api_and_content_store_have_page(
      "a-slug",
      'web_url' => 'http://example.org/a-slug',
      'format' => 'business_support',
      "details" => { 'body' => 'A business support related body' }
    )
    prevent_implicit_rendering
    get :publication, slug: "a-slug", part: "information"
    assert_response :redirect
    assert_redirected_to '/a-slug'
  end

  test "should assign edition to template if it's not blank and a number" do
    edition_id = '23'
    slug = 'a-slug'

    content_api_and_content_store_have_unpublished_page(
      slug,
      edition_id,
      "format" => "local_transaction",
      "web_url" => "http://example.org/slug"
    )

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
      artefact = artefact_for_slug('slug').merge("format" => "local_transaction")
      artefact["details"]["language"] = 'pt'
      content_api_and_content_store_have_page('slug', artefact)

      I18n.expects(:locale=).with('pt')

      get :publication, slug: 'slug'
    end

    should "not set the locale if the artefact has no language" do
      artefact = artefact_for_slug('slug').merge("format" => "local_transaction")
      artefact["details"].delete("language")
      content_api_and_content_store_have_page('slug', artefact)

      I18n.expects(:locale=).never

      get :publication, slug: 'slug'
    end
  end

  test "objects should have specified parts selected" do
    setup_this_publication
    prevent_implicit_rendering
    @controller.stubs(:render).with("business_support")
    get :publication, slug: "c-slug", part: "second_part"
    assert_equal "Second Part", assigns["publication"].current_part.name
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
end
