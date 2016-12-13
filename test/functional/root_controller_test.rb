require 'test_helper'
require 'gds_api/test_helpers/mapit'

class RootControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Mapit

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
    content_api_and_content_store_have_page("a-slug", 'format' => 'local_transaction')
    prevent_implicit_rendering
    @controller.expects(:render).with("local_transaction")
    get :publication, slug: "a-slug"
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
    content_api_and_content_store_have_unpublished_page(slug, edition_id)

    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, slug: "c-slug", edition: edition_id
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

  context "for refactored formats" do
    setup do
      content_api_and_content_store_have_page(
        "refactored-answer-format-slug'",
        'format' => 'answer',
        'details' => {
          'name' => 'An answer',
        })
    end

    should "return cacheable 404" do
      get :publication, slug: "refactored-answer-format-slug'"

      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
    end

    should "return 404 for POST method" do
      post :publication, slug: "refactored-answer-format-slug'"

      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
    end
  end
end
