require "test_helper"

class TransactionControllerTest < ActionController::TestCase
  context "GET show" do
    setup do
      @artefact = artefact_for_slug('register-to-vote')
      @artefact["format"] = "answer"
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
end
