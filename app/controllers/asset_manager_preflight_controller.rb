# A draft document can contain several draft images, and each one
# independently triggers its own Asset Manager/Signon authentication
# handshake when there's no existing Asset Manager session. Because
# those handshakes can complete out of order, they invalidate each
# other's session state and the images fail to load. To avoid this,
# we make sure a single Asset Manager session has already been
# established before rendering any draft page that might contain draft images.
#
# This controller loads a single, permanent, harmless placeholder image
# from Asset Manager's draft assets host. That's enough to complete one
# Signon handshake and establish an Asset Manager session cookie in the
# browser - the user should already have an active Signon session by the
# time they reach a draft preview, so this is just completing a handshake,
# not asking them to sign in again.
#
# Once that's done - or once we've given it a reasonable amount of time to
# finish - we bounce the user back to the page they originally asked for.
# From then on, every image request on that page reuses the now-warm Asset
# Manager session instead of starting its own handshake.
class AssetManagerPreflightController < ApplicationController
  include DraftHelper

  skip_before_action :redirect_to_asset_manager_preflight_if_required # avoid circular loop

  # Query params that are either meaningless to forward (Rails routing
  # internals) or that we set ourselves and must never let an incoming
  # request's own query string collide with/override - most importantly
  # return_to, which AssetManagerPreflightController trusts to build a
  # same-host redirect.
  ASSET_MANAGER_PREFLIGHT_RESERVED_PARAMS = %w[return_to controller action].freeze
  ASSET_MANAGER_SESSION_KEY = :asset_manager_session_set_up
  ASSET_MANAGER_PREFLIGHT_TTL = 30.minutes

  PLACEHOLDER_ASSET_PATH = "/media/5e59279b86650c53b2cefbfe/placeholder.jpg".freeze

  def show
    raise GdsApi::HTTPNotFound, "Not found" unless draft_host?

    set_no_cache_headers

    session[ASSET_MANAGER_SESSION_KEY] = Time.zone.now.to_i

    render layout: false
  end

  helper_method :placeholder_asset_url, :return_to_path

private

  def placeholder_asset_url
    url = Plek.find("draft-assets") + PLACEHOLDER_ASSET_PATH
    forwarded_params.any? ? "#{url}?#{forwarded_params.to_query}" : url
  end

  def forwarded_params
    params
      .to_unsafe_h
      .except(*ASSET_MANAGER_PREFLIGHT_RESERVED_PARAMS)
  end

  # This is the one place in this feature that decides where a user's
  # browser actually navigates to, so it's the one place an open redirect
  # could sneak in: /draft-asset-preflight is a directly-hittable
  # route (albeit only on the draft stack, which is behind Signon),
  # so return_to must be treated as attacker-controlled input.
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
