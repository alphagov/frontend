# Short-term workaround for WHIT-3992-style failures where a draft page
# with several images ends up firing off several concurrent Asset
# Manager/Signon authentication handshakes, whose responses can come back
# out of order and invalidate each other's session state.
#
# ApplicationController redirects here (see
# #redirect_to_asset_manager_preflight_if_required) before rendering the
# first draft-host page in a browsing session. This page loads a single,
# permanent, harmless placeholder image from Asset Manager's draft assets
# host. That's enough to complete one Signon handshake and establish an
# Asset Manager session cookie in the browser - the user should already
# have an active Signon session by the time they reach a draft preview, so
# this is just completing a handshake, not asking them to sign in again.
# (Or, if the request carries a Whitehall/Publishing API "auth bypass"
# token - because a publisher generated a preview link for someone without
# a Signon account - we forward that (and any other query params the
# original request had) onto the placeholder asset request too, so
# Authenticating Proxy can set the auth bypass cookie instead.)
#
# Once that's done - or once we've given it a reasonable amount of time to
# finish - we bounce the user back to the page they originally asked for.
# From then on, every image request on that page reuses the now-warm Asset
# Manager session instead of starting its own handshake.
#
# This mirrors the equivalent hack in Whitehall (the
# client-driven-preflight-login branch, which loads the same kind of
# placeholder image on every admin page). See WHIT-3992 for background.
class AssetManagerPreflightController < ApplicationController
  skip_before_action :redirect_to_asset_manager_preflight_if_required

  PLACEHOLDER_ASSET_PATH = "/media/5e59279b86650c53b2cefbfe/placeholder.jpg".freeze

  def show
    set_no_cache_headers

    cookies[ApplicationController::ASSET_MANAGER_PREFLIGHT_COOKIE] = {
      value: "1",
      expires: ApplicationController::ASSET_MANAGER_PREFLIGHT_TTL.from_now,
      httponly: true,
      same_site: :lax,
    }

    render layout: false
  end

  helper_method :placeholder_asset_url, :return_to_path

private

  # Forward on whatever query params the original request had (minus the
  # ones we manage ourselves) - most importantly the Whitehall/Publishing
  # API access-limiting bypass token, but anything else too, in case
  # there's some other auth-relevant param we haven't thought of. This
  # only ever affects the query string of a request to a fixed,
  # hardcoded host (Asset Manager's draft assets host) - it can't be used
  # to redirect anyone anywhere, and every value is percent-encoded via
  # Hash#to_query before it goes anywhere near a URL.
  def placeholder_asset_url
    url = Plek.find("draft-assets") + PLACEHOLDER_ASSET_PATH
    forwarded_params.any? ? "#{url}?#{forwarded_params.to_query}" : url
  end

  def forwarded_params
    params
      .to_unsafe_h
      .except(*ApplicationController::ASSET_MANAGER_PREFLIGHT_RESERVED_PARAMS)
  end

  # This is the one place in this feature that decides where a user's
  # browser actually navigates to, so it's the one place an open redirect
  # could sneak in: /draft-asset-preflight is a public, directly-hittable
  # route, so return_to must be treated as attacker-controlled input, not
  # just "the value we happened to set when we redirected here ourselves".
  # Only ever redirect back to a same-host, same-app path - never a
  # scheme-relative ("//host/...") or absolute ("https://host/...") URL.
  def return_to_path
    path = params[:return_to].to_s
    safe_return_to?(path) ? path : "/"
  end

  def safe_return_to?(path)
    path.start_with?("/") && !path.start_with?("//") && !path.include?("://")
  end
end
