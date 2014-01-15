require_relative '../test_helper'

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

  test "should redirect requests for JSON" do
    setup_this_answer
    get :publication, :slug => 'c-slug', :format => 'json'
    assert_response :redirect
    assert_redirected_to "/api/c-slug.json"
  end

  test "should not redirect request for places JSON" do
    content_api_has_an_artefact("d-slug", {
      'slug' => 'c-slug',
      'format' => 'place',
      'details' => {
        'name' => 'THIS'
      }
    })

    get :publication, :slug => 'd-slug', :format => 'json'
    assert_response :success
  end

  test "should redirect JSON requests for local transactions with a parameter for the appropriate snac code" do
    artefact = {
      "title" => "Find your local cake sale",
      "format" => "local_transaction",
      "details" => {
        "format" => "LocalTransaction",
        "local_service" => {
          "description" => "Find your local cake sale",
          "lgsl_code" => "1234",
          "providing_tier" => [ "district", "unitary" ]
        }
      }
    }
    artefact_with_interaction = artefact.dup
    artefact_with_interaction["details"].merge({
      "local_interaction" => {
        "lgsl_code" => 461,
        "lgil_code" => 8,
        "url" => "http://www.torfaen.gov.uk/en/moar-caek.aspx"
      },
      "local_authority" => {
        "name" => "Torfaen County Borough Council",
        "contact_details" => [
          "Moorlands House",
          "Stockwell Street",
          "Leek",
          "Staffordshire",
          "ST13 6HQ"
        ],
        "contact_url" => "http://www.torfaen.gov.uk/en/moar-caek.aspx"
      }
    })

    content_api_has_an_artefact("find-local-cake-sale", artefact)
    content_api_has_an_artefact_with_snac_code("find-local-cake-sale", "00PM", artefact_with_interaction)

    get :publication, :slug => 'find-local-cake-sale', :part => "torfaen", :format => 'json'
    assert_response :redirect
    assert_redirected_to "/api/find-local-cake-sale.json?snac=00PM"
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

  test "should 404 when asked for unrecognised format" do
    content_api_has_an_artefact("a-slug")

    get :publication, :slug => 'a-slug', :format => '123'
    assert_equal '404', response.code
  end

  test "should 404 when asked for an artefact that has an unsupported format" do
    artefact = artefact_for_slug("a-slug").merge("format" => "licence-finder")
    content_api_has_an_artefact("a-slug", artefact)

    get :publication, :slug => 'a-slug'
    assert_equal '404', response.code
  end

  test "should return a cacheable 404 withoug calling content_api if slug isn't URL friendly" do
    get :publication, :slug => "a complicated slug & one that's not \"url safe\""
    assert_equal "404", response.code
    assert_equal "max-age=600, public",  response.headers["Cache-Control"]
    assert_not_requested(:get, %r{\A#{CONTENT_API_ENDPOINT}})
  end

  test "should return a cacheable 404 without calling content_api if a slug has invalid UTF-8 chars in it" do
    get :publication, :slug => "fco\xA0"
    assert_equal "404", response.code
    assert_equal "max-age=600, public",  response.headers["Cache-Control"]
    assert_not_requested(:get, %r{\A#{CONTENT_API_ENDPOINT}})
  end

  test "should return a cacheable 404 without calling content_api if a slug has malformed UTF-8 chars in it" do
    get :publication, :slug => "br54ba\x9CAQ\xC4\xFD\x928owse"
    assert_equal "404", response.code
    assert_equal "max-age=600, public",  response.headers["Cache-Control"]
    assert_not_requested(:get, %r{\A#{CONTENT_API_ENDPOINT}})
  end

  test "should return a 404 if content_api returns a 404 (nil)" do
    content_api_does_not_have_an_artefact("banana")
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "banana"
  end

  test "should return a 410 if content_api returns a 410" do
    content_api_has_an_archived_artefact("atlantis")
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 410))
    get :publication, :slug => "atlantis"
  end

  test "should choose template based on type of publication" do
    content_api_has_an_artefact("a-slug", {'format' => 'answer'})
    prevent_implicit_rendering
    @controller.expects(:render).with("answer")
    get :publication, :slug => "a-slug"
  end

  test "should set expiry headers for an edition" do
    content_api_has_an_artefact("a-slug")

    get :publication, :slug => 'a-slug'
    assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
  end

  test "further information tab should appear for programmes that have it" do
    content_api_has_an_artefact("zippy", {'slug' => 'zippy', 'format' => 'programme', "web_url" => "http://example.org/slug","details" => {'parts' => [
            {'slug' => 'a', 'name' => 'AA'},
            {'slug' => 'further-information', 'name' => 'BB', 'body' => "abc"}
          ]}})
    get :publication, :slug => "zippy"
    assert @response.body.include? "further-information"
  end

  test "further information tab should not appear for programmes where it is empty" do
    content_api_has_an_artefact("zippy", {'slug' => 'zippy', 'format' => 'programme', "web_url" => "http://example.org/slug","details" => {'parts' => [
            {'slug' => 'a', 'name' => 'AA'},
            {'slug' => 'further-information', 'name' => 'BB'}
          ]}})
    get :publication, :slug => "zippy"
    assert_false @response.body.include? "further-information"
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

  test "should return print view" do
    content_api_has_an_artefact("a-slug")

    prevent_implicit_rendering
    @controller.expects(:render).with("guide")
    get :publication, :slug => "a-slug", :format => "print"
    # assert_template 'guide'
    assert_equal "print", @request.format
  end

  test "should return 404 when print view of a non-=supported format is requested" do
    content_api_has_an_artefact("a-slug", artefact_for_slug("a-slug").merge("format" => "answer"))

    get :publication, :slug => "a-slug", :format => "print"
    assert_equal 404, response.status
  end

  test "should return 404 if part requested but publication has no parts" do
    content_api_has_an_artefact("a-slug", {
      'web_url' => 'http://example.org/a-slug', 'format' => 'guide', "details" => {'parts' => []}
    })

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status => 404))
    get :publication, :slug => "a-slug", :part => "information"
  end

  test "should redirect to base url if bad part requested of multi-part guide" do
    content_api_has_an_artefact("a-slug", {
      'web_url' => 'http://example.org/a-slug', 'format' => 'guide', "details" => {'parts' => [{'title' => 'first', 'slug' => 'first'}]}
    })
    prevent_implicit_rendering
    get :publication, :slug => "a-slug", :part => "information"
    assert_response :redirect
    assert_redirected_to '/a-slug'
  end

  test "should redirect to base url if part requested for non-parted format" do
    content_api_has_an_artefact("a-slug", {
      'web_url' => 'http://example.org/a-slug', 'format' => 'answer', "details" => {'body' => 'An answer'}
    })
    prevent_implicit_rendering
    get :publication, :slug => "a-slug", :part => "information"
    assert_response :redirect
    assert_redirected_to '/a-slug'
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

  test "Should redirect to transaction if no geo header" do
    content_api_has_an_artefact("c-slug")

    request.env.delete("HTTP_X_GOVGEO_STACK")
    get :publication, :slug => "c-slug"
  end

  context "setting the locale" do
    should "set the locale to the artefact's locale" do
      artefact = artefact_for_slug('slug')
      artefact["details"]["language"] = 'pt'
      content_api_has_an_artefact('slug', artefact)

      I18n.expects(:locale=).with('pt')

      get :publication, :slug => 'slug'
    end

    should "not set the locale if the artefact has no language" do
      artefact = artefact_for_slug('slug')
      artefact["details"].delete("language")
      content_api_has_an_artefact('slug', artefact)

      I18n.expects(:locale=).never

      get :publication, :slug => 'slug'
    end

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

    should "fudge the section for help pages" do
      artefact_data = artefact_for_slug('slug')
      artefact_data["format"] = "help_page"
      content_api_has_an_artefact("slug", artefact_data)
      @controller.stubs(:render)

      get :publication, :slug => "slug"

      slimmer_artefact = JSON.parse(@response.headers["X-Slimmer-Artefact"])
      slimmer_section = slimmer_artefact["tags"][0]
      assert_equal "section", slimmer_section["details"]["type"]
      assert_equal "Help", slimmer_section["title"]
      assert_equal "/help", slimmer_section["content_with_tag"]["web_url"]
    end
  end

  test "objects should have specified parts selected" do
    setup_this_answer
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug", :part => "b"
    assert_equal "BB", assigns["publication"].current_part.name
  end

  test "should work with place editions" do
    content_api_has_an_artefact("a-slug", artefact_for_slug("a-slug").merge({
          'format' => 'place', 'details' => {}}))
    prevent_implicit_rendering
    get :publication, :slug => "a-slug"
    assert_equal '200', response.code
  end

  context "loading the homepage" do
    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  context "loading the tour page" do
    should "respond with success" do
      get :tour
      assert_response :success
    end

    should "set correct expiry headers" do
      get :tour
      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  context "loading the legacy transaction finished page" do
    context "given an artefact for 'transaction-finished' exists" do
      setup do
        @details = {
          'slug' => 'transaction-finished',
          'web_url' => 'https://www.preview.alphagov.co.uk/transaction-finished',
          'format' => 'completed_transaction'
        }
        content_api_has_an_artefact('transaction-finished', @details)
      end

      should "respond with success" do
        get :legacy_completed_transaction, :slug => "transaction-finished"
        assert_response :success
      end

      should "load the correct details" do
        get :legacy_completed_transaction, :slug => "transaction-finished"
        url = "https://www.preview.alphagov.co.uk/transaction-finished"
        assert_equal url, assigns(:publication).web_url
      end

      should "render the legacy completed transaction view" do
        get :legacy_completed_transaction, :slug => "transaction-finished"
        assert_template "legacy_completed_transaction"
      end
    end
  end

  context "loading the jobsearch page" do
    context "given an artefact for 'jobs-jobsearch' exists" do
      setup do
        @details = {
          'slug' => 'jobs-jobsearch',
          'web_url' => 'https://www.preview.alphagov.co.uk/jobs-jobsearch',
          'format' => 'transaction',
          'details' => {"expectations" => []},
          'title' => 'Universal Jobsearch'
        }
        content_api_has_an_artefact("jobs-jobsearch", @details)
      end

      should "respond with success" do
        get :jobsearch, :slug => "jobs-jobsearch"
        assert_response :success
      end

      should "loads the correct details" do
        get :jobsearch, :slug => "jobs-jobsearch"
        assert_equal "Universal Jobsearch", assigns(:publication).title
      end

      should "initialize a publication object" do
        get :jobsearch, :slug => "jobs-jobsearch"
        assert_equal "Universal Jobsearch", assigns(:publication).title
      end

      should "set correct slimmer artefact in headers" do
        get :jobsearch, :slug => "jobs-jobsearch"
        assert_equal JSON.dump(@details), @response.headers["X-Slimmer-Artefact"]
      end

      should "set correct expiry headers" do
        get :jobsearch, :slug => "jobs-jobsearch"
        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end

      should "render the jobsearch view" do
        get :jobsearch, :slug => "jobs-jobsearch"
        assert_template "jobsearch"
      end
    end

    context "given a welsh version exists" do
      setup do
        @details = {
          'id' => 'https://www.gov.uk/api/jobs-jobsearch-welsh.json',
          'web_url' => 'https://www.preview.alphagov.co.uk/jobs-jobsearch-welsh',
          'format' => 'transaction',
          'details' => {"expectations" => [], "language" => "cy"},
          'title' => 'Universal Jobsearch'
        }
        content_api_has_an_artefact("jobs-jobsearch-welsh", @details)
      end

      should "set the locale to welsh" do
        I18n.expects(:locale=).with("cy")
        get :jobsearch, :slug => "jobs-jobsearch-welsh"
      end
    end

    context "given an artefact does not exist" do
      setup do
        content_api_does_not_have_an_artefact('jobs-jobsearch')
      end

      should "respond with 404" do
        get :jobsearch, :slug => "jobs-jobsearch"
        assert_response :not_found
      end
    end
  end
end
