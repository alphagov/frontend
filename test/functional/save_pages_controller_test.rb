require "test_helper"
require "gds_api/test_helpers/account_api"

class SavePagesControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include SessionHelpers

  context "when FEATURE_FLAG_SAVE_A_PAGE environment variable is not 'enabled'" do
    context "GET /account/saved-pages/add" do
      should "return 404" do
        get :create, params: { page_path: ministry_of_magic_path }
        assert_response :not_found
      end
    end

    context "GET /account/saved-pages/remove" do
      should "return 404" do
        get :destroy, params: { page_path: ministry_of_magic_path }
        assert_response :not_found
      end
    end
  end

  context "when FEATURE_FLAG_SAVE_A_PAGE environment variable is set to 'enabled'" do
    context "GET /account/saved-pages/add" do
      context "when logged out" do
        setup do
          @stub = stub_account_api_get_sign_in_url(
            level_of_authentication: "level0",
            redirect_path: save_page_path(
              page_path: ministry_of_magic_path,
            ),
          )
        end

        should "redirect the user to the Auth Provider" do
          with_feature_flag_enabled do
            get :create, params: { page_path: ministry_of_magic_path }
            assert_response :redirect

            assert_response :redirect
            assert_requested @stub
          end
        end
      end

      context "when logged in" do
        setup do
          mock_logged_in_session
          stub_account_api_save_page(page_path: "/government/organisations/ministry-of-magic", new_govuk_account_session: "placeholder")
        end

        should "create a saved page and redirect the user to the saved page_path" do
          with_feature_flag_enabled do
            get :create, params: { page_path: ministry_of_magic_path }
            assert_response :redirect

            path = Addressable::URI.parse(@response.headers["Location"]).path
            assert_equal path, ministry_of_magic_path
          end
        end

        should "report a successful save to the requesting app with a query parameter" do
          with_feature_flag_enabled do
            get :create, params: { page_path: ministry_of_magic_path }
            assert_response :redirect

            query = Addressable::URI.parse(@response.headers["Location"]).query
            assert_includes query, "personalisation=page_saved"
          end
        end

        should "report an unsuccessful save to the requesting app with a query parameter" do
          with_feature_flag_enabled do
            stub_account_api_save_page_cannot_save_page(
              page_path: ministry_of_magic_path,
              new_govuk_account_session: "placeholder",
            )

            get :create, params: { page_path: ministry_of_magic_path }
            assert_response :redirect

            query = Addressable::URI.parse(@response.headers["Location"]).query
            assert_equal query, "personalisation=page_not_saved"
          end
        end

        should "protect against a redirect attack from a failed save page request" do
          with_feature_flag_enabled do
            stub_account_api_save_page_cannot_save_page(
              page_path: ministry_of_magic_path,
              new_govuk_account_session: "placeholder",
            )

            get :create, params: { page_path: "https://evil.g0v.uk#{ministry_of_magic_path}" }
            assert_response :redirect

            path = Addressable::URI.parse(@response.headers["Location"]).path
            query = Addressable::URI.parse(@response.headers["Location"]).query
            assert_equal query, "personalisation=page_not_saved"
            assert_equal path, ministry_of_magic_path
          end
        end
      end
    end

    context "GET /account/saved_pages/remove" do
      context "when logged out" do
        setup do
          @stub = stub_account_api_get_sign_in_url(
            level_of_authentication: "level0",
            redirect_path: remove_saved_page_path(
              page_path: ministry_of_magic_path,
            ),
          )
        end

        should "redirect the user to the Auth Provider" do
          with_feature_flag_enabled do
            get :destroy, params: { page_path: ministry_of_magic_path }
            assert_response :redirect

            assert_response :redirect
            assert_requested @stub
          end
        end
      end

      context "when logged in" do
        setup do
          mock_logged_in_session
          stub_account_api_delete_saved_page(
            page_path: ministry_of_magic_path,
            new_govuk_account_session: "placeholder",
          )
        end

        should "delete a saved page and redirect the user to the saved page_path" do
          with_feature_flag_enabled do
            get :destroy, params: { page_path: ministry_of_magic_path }
            assert_response :redirect

            path = Addressable::URI.parse(@response.headers["Location"]).path
            assert_equal path, ministry_of_magic_path
          end
        end

        should "report an unsuccessful save to the requesting app with a query parameter" do
          with_feature_flag_enabled do
            get :destroy, params: { page_path: ministry_of_magic_path }
            assert_response :redirect

            query = Addressable::URI.parse(@response.headers["Location"]).query
            assert_equal query, "personalisation=page_removed"
          end
        end
      end
    end
  end

  def ministry_of_magic_path
    "/government/organisations/ministry-of-magic"
  end

  def with_feature_flag_enabled(&block)
    ClimateControl.modify(FEATURE_FLAG_SAVE_A_PAGE: "enabled", &block)
  end
end
