require "test_helper"

class TransactionControllerTest < ActionController::TestCase
  context "GET show" do
    setup do
      @artefact = artefact_for_slug('register-to-vote')
      @artefact["format"] = "transaction"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('register-to-vote', @artefact)
      end

      should "set the cache expiry headers" do
        get :show, slug: "register-to-vote"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "register-to-vote", format: 'json'

        assert_redirected_to "/api/register-to-vote.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("register-to-vote", 3, @artefact)
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "register-to-vote", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end

    should "not allow framing of transaction pages" do
      content_api_and_content_store_have_page("a-slug", 'slug' => 'a-slug',
        'web_url' => 'https://example.com/a-slug',
        'format' => 'transaction',
        'details' => { "need_to_know" => "" },
        'title' => 'A Test Transaction')

      get :show, slug: 'a-slug'
      assert_equal "DENY", @response.headers["X-Frame-Options"]
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
        get :show, slug: "jobsearch"
        assert_response :success
      end

      should "loads the correct details" do
        get :show, slug: "jobsearch"
        assert_equal "Universal Jobsearch", assigns(:publication).title
      end

      should "initialize a publication object" do
        get :show, slug: "jobsearch"
        assert_equal "Universal Jobsearch", assigns(:publication).title
      end

      should "set correct expiry headers" do
        get :show, slug: "jobsearch"
        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "render the jobsearch view" do
        get :show, slug: "jobsearch"
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
        get :show, slug: "chwilio-am-swydd"
      end
    end

    context "given a version in an unsupported language exists" do
      setup do
        @details = {
          'id' => 'https://www.gov.uk/api/document-in-turkmen.json',
          'web_url' => 'https://www.preview.alphagov.co.uk/document-in-turkmen',
          'format' => 'transaction',
          'details' => { "need_to_know" => "", "language" => "tk" },
          'title' => 'Some title'
        }
        content_api_and_content_store_have_page("document-in-turkmen", @details)
      end

      should "set the locale to the English default" do
        I18n.expects(:locale=).with(:en)
        get :show, slug: "document-in-turkmen"
      end
    end
  end
end
