require 'test_helper'

class RootControllerTest < ActionController::TestCase

  def setup_this_answer
    publication_exists(
      'slug' => 'c-slug',
      'type' => 'answer',
      'name' => 'THIS',
      'parts' => [
        {'slug' => 'a', 'name' => 'AA'},
        {'slug' => 'b', 'name' => 'BB'}
      ]
    )
    panopticon_has_metadata('slug' => 'c-slug', 'id' => '12345')
  end

  def panopticon_has_metadata( metadata )
    defaults = {
      'slug' => 'slug',
      'id' => '12345',
      'section' => 'Test',
      'need_id' => '12345',
      'kind' => 'guide'
    }

    super defaults.merge(metadata)
  end

  def stub_edition_request(slug, edition_id)
    @api = mock()
    @api.expects(:publication_for_slug).with(slug, {:edition => edition_id}).returns(OpenStruct.new(:type => "answer"))
    @controller.stubs(:publisher_api).returns(@api)
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  test "should return a 404 if asked for a guide without parts" do
    publication_exists(
      "slug" => "disability-living-allowance-guide",
      "alternative_title" => "",
      "overview" => "",
      "title" => "Disability Living Allowance",
      "parts" => [],
      "type" => "guide"
    )
    panopticon_has_metadata('slug' => "disability-living-allowance-guide")
    get :publication, :slug => "disability-living-allowance-guide"
    assert_equal '404', response.code
  end

  test "should return a 404 if api returns nil" do
    publication_does_not_exist('slug' => 'a-slug')
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug"
  end

  test "should 406 when asked for KML for a non-place publication" do
    publication_exists('slug' => 'a-slug', 'type' => 'answer')
    panopticon_has_metadata('slug' => 'a-slug')

    get :publication, :slug => 'a-slug', :format => 'kml'
    assert_equal '406', response.code
  end

  test "options not set when asked for KML for a place publication" do
    publication_exists('slug' => 'a-slug', 'type' => 'place')
    panopticon_has_metadata('slug' => 'a-slug')
    GdsApi::Imminence.any_instance.stubs(:places_kml)

    get :publication, :slug => 'a-slug', :format => 'kml'
    assert_nil assigns[:options]
  end

  test "should 406 when asked for unrecognised format" do
    publication_exists('slug' => 'a-slug', 'type' => 'answer')
    panopticon_has_metadata('slug' => 'a-slug')

    get :publication, :slug => 'a-slug', :format => '123'
    assert_equal '406', response.code
  end

  test "should return a 404 if slug isn't URL friendly" do
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "a complicated slug & one that's not \"url safe\""
  end

  test "should choose template based on type of publication" do
    publication_exists('slug' => 'a-slug', 'type' => 'answer')
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    @controller.expects(:render).with("answer")
    get :publication, :slug => "a-slug"
  end

  test "further information tab should appear for programmes that have it" do
    publication_exists('slug' => 'zippy', 'type' => 'programme', 'parts' => [
        {'slug' => 'a', 'name' => 'AA'},
        {'slug' => 'further-information', 'name' => 'BB'}
      ])
    panopticon_has_metadata('slug' => 'zippy')
    get :publication, :slug => "zippy"
    assert @response.body.include? "further-information"
  end

  test "further information tab should not appear for programmes that don't have it" do
    publication_exists('slug' => 'george', 'type' => 'programme', 'parts' => [
        {'slug' => 'a', 'name' => 'AA'},
        {'slug' => 'b', 'name' => 'BB'}
      ])
    panopticon_has_metadata('slug' => 'george')
    get :publication, :slug => "george"
    assert !@response.body.include?("further-information")
  end

  test "should pass edition parameter on to api to provide preview" do
    edition_id = '123'
    slug = 'c-slug'
    stub_edition_request(slug, edition_id)
    panopticon_has_metadata('slug' => slug)

    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, :slug => "c-slug", :edition => edition_id
  end

  test "should return video view when asked if guide has video" do
    publication_exists('slug' => 'a-slug', 'type' => 'guide', 'video_url' => 'bob')
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.expects(:render).with("guide", layout: "application.html.erb")
    get :publication, :slug => "a-slug", :format => "video"
    assert_equal "video", @request.format
  end

  test "should not throw an error when an invalid video url is specified" do
    publication_exists('slug' => 'a-slug', 'type' => 'guide', 'video_url' => 'bob', 'updated_at' => 1.hour.ago, 'parts' => [
        {'title' => 'Part 1', 'slug' => 'part-1', 'body' => 'Part 1 I am'}])
    panopticon_has_metadata('slug' => 'a-slug')

    get :publication, :slug => "a-slug"
    get :publication, :slug => "a-slug", :format => "video"
  end

  test "should return print view" do
    publication_exists(
      'slug' => 'a-slug', 'type' => 'guide', 'name' => 'THIS', 'parts' => [
        {'title' => 'Part 1', 'slug' => 'part-1', 'body' => 'Part 1 I am'}
      ]
    )
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.expects(:render).with("guide")
    get :publication, :slug => "a-slug", :format => "print"
    # assert_template 'guide'
    assert_equal "print", @request.format
  end

  test "should return 404 if video requested but guide has no video" do
    publication_exists('slug' => 'a-slug', 'type' => 'guide', 'name' => 'THIS')
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "a-slug", :format => "video"
  end

  test "should return 404 if part requested but publication has no parts" do
    publication_exists('slug' => 'a-slug', 'type' => 'answer', 'name' => 'THIS')
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "a-slug", :part => "information"
  end

  test "should redirect to first part if bad part requested of multi-part guide" do
    publication_exists('slug' => 'a-slug', 'type' => 'guide', 'parts' => [{'title' => 'first', 'slug' => 'first'}])
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    get :publication, :slug => "a-slug", :part => "information"
    assert_response :redirect
    assert_redirected_to "/a-slug/first"
  end

  test "should redirect to canonical URL for first part if top level guide URL is requested" do
    publication_exists('slug' => 'a-slug', 'type' => 'guide', 'parts' => [{'title' => 'first', 'slug' => 'first'}])
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    get :publication, :slug => "a-slug"
    assert_response :redirect
    assert_redirected_to "/a-slug/first"
  end

  test "should preserve query parameters when redirecting" do
    publication_exists({'slug' => 'a-slug', 'type' => 'guide', 'parts' => [{'title' => 'first', 'slug' => 'first'}]}, {:edition => 3})
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    get :publication, :slug => "a-slug", :some_param => 1, :edition => 3
    assert_response :redirect
    assert_redirected_to "/a-slug/first?edition=3&some_param=1"
  end

  test "should not redirect to first part URL if request is for JSON" do
    publication_exists('slug' => 'a-slug', 'type' => 'guide', 'parts' => [{'title' => 'first', 'slug' => 'first'}])
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    get :publication, slug: "a-slug", format: 'json'
    assert_response :success
  end

  test "should assign edition to template if it's not blank and a number" do
    edition_id = '23'
    slug = 'a-slug'
    stub_edition_request(slug, edition_id)
    panopticon_has_metadata('slug' => slug)

    prevent_implicit_rendering
    get :publication, :slug => "a-slug", :edition => edition_id
    assigns[:edition] = edition_id
  end

  test "should not pass edition parameter on to api if it's blank" do
     edition_id = ''
     api = mock()
     api.expects(:publication_for_slug).with("a-slug", {}).returns(OpenStruct.new(:type=>"answer"))
     @controller.stubs(:publisher_api).returns api
     panopticon_has_metadata('slug' => 'a-slug')

     prevent_implicit_rendering
     @controller.stubs(:render)
     get :publication, :slug => "a-slug",:edition => edition_id
  end

  test "should pass specific and general variables to template" do
    publication_exists('slug' => 'c-slug', 'type' => 'answer', 'name' => 'THIS')
    panopticon_has_metadata('slug' => 'c-slug')

    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug"
    assert_equal "THIS", assigns["publication"].name
    assert_equal "THIS", assigns["answer"].name
  end

  test "Should redirect to transaction if no geo header" do
    publication_exists('slug' => 'c-slug', 'type' => 'local_transaction', 'name' => 'THIS')
    panopticon_has_metadata('slug' => 'c-slug')

    request.env.delete("HTTP_X_GOVGEO_STACK")
    no_council_for_slug('c-slug')
    get :publication, :slug => "c-slug"
  end

  test "should hard code proposition on the home page" do
    get :index

    assert_equal "citizen", @response.headers["X-Slimmer-Proposition"]
  end

  test "should expose artefact details in header" do
    panopticon_has_metadata('slug' => 'slug', 'section' => "rhubarb", 'need_id' => 42, 'kind' => "answer")
    publication_exists('slug' => 'slug')
    @controller.stubs(:render)

    get :publication, :slug => "slug"

    assert_equal "rhubarb", @response.headers["X-Slimmer-Section"]
    assert_equal "42",      @response.headers["X-Slimmer-Need-ID"].to_s
    assert_equal "answer",  @response.headers["X-Slimmer-Format"]
  end

  test "should set proposition to citizen" do
    publication_exists('slug' => 'slug')
    panopticon_has_metadata('slug' => 'slug', 'id' => '12345', 'section' => 'Test', 'need_id' => 123, 'kind' => 'guide')
    @controller.stubs(:render)

    get :publication, :slug => "slug"

    assert_equal "citizen", @response.headers["X-Slimmer-Proposition"]
  end

  test "should set proposition to business for business content" do
    publication_exists("slug" => "slug")
    panopticon_has_metadata("slug" => "slug", "id" => "12345", "section" => "Test", "need_id" => 123, "kind" => "guide", "business_proposition" => true)
    @controller.stubs(:render)

    get :publication, :slug => "slug"

    assert_equal "business", @response.headers["X-Slimmer-Proposition"]
  end

  test "sets up a default artefact if panopticon isn't available" do
    @controller.panopticon_api.stubs(:artefact_for_slug).returns(nil)
    @controller.stubs(:render)
    publication_exists('slug' => 'slug')

    get :publication, slug: "slug"

    assert_equal "missing", @response.headers["X-Slimmer-Section"]
    assert_equal "missing", @response.headers["X-Slimmer-Need-ID"].to_s
    assert_equal "missing", @response.headers["X-Slimmer-Format"]
  end

  test "objects should have specified parts selected" do
    setup_this_answer
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug", :part => "b"
    assert_equal "BB", assigns["part"].name
  end

  context "local transactions" do
    def setup_publisher_api(slug, snac)
      json = File.read(Rails.root.join("test/fixtures/#{slug}.json"))
      artefact_info = {
        "slug" => slug,
        "section" => "transport"
      }
      publication_info = JSON.parse(json)
      publication_exists_for_snac(snac, publication_info)
      panopticon_has_metadata(artefact_info)
    end

    should "load local transaction with no interaction for snac" do
      slug = "apply-direct-payments-edinburgh"
      snac = "00QP"
      setup_publisher_api(slug, snac)

      post :publication, format: "json", slug: slug, council_ons_codes: [snac]

      json = JSON.parse(response.body)
      assert_equal slug, json['slug']
      assert_equal "London Borough of Lambeth", json['council']['name']
      assert_nil json['council']['url']
      assert_equal "contact@lambeth.gov.uk", json['council']['contact_email']
    end

    should "load legacy local transaction with no interaction for snac" do
      slug = "apply-direct-payments-edinburgh-legacy"
      snac = "00QP"
      setup_publisher_api(slug, snac)

      post :publication, format: "json", slug: slug, council_ons_codes: [snac]

      json = JSON.parse(response.body)
      assert_equal slug, json['slug']
      assert_nil json['council']
    end

    should "load local transaction with interaction for snac" do
      slug = "apply-direct-payments-lambeth"
      snac = "00QP"
      setup_publisher_api(slug, snac)

      post :publication, format: "json", slug: slug, council_ons_codes: [snac]

      json = JSON.parse(response.body)
      assert_equal slug, json['slug']
      assert_equal "http://www.lambeth.gov.uk/Services/HealthSocialCare/ServicesAdults/DirectPayments.htm", json['council']['url']
      assert_equal "London Borough of Lambeth", json['council']['name']
      assert_equal "contact@lambeth.gov.uk", json['council']['contact_email']
    end

    should "load legacy local transaction with interaction for snac" do
      slug = "apply-direct-payments-lambeth-legacy"
      snac = "00QP"
      setup_publisher_api(slug, snac)

      post :publication, format: "json", slug: slug, council_ons_codes: [snac]

      json = JSON.parse(response.body)
      assert_equal slug, json['slug']
      assert_equal "http://www.lambeth.gov.uk/Services/HealthSocialCare/ServicesAdults/DirectPayments.htm", json['council']['url']
      assert_equal "London Borough of Lambeth", json['council']['name']
      assert_equal "contact@lambeth.gov.uk", json['council']['contact_email']
    end
  end
end
