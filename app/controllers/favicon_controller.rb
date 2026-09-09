# Because favicon has to be present at root, we need a controller
# to redirect it to the asset. When there's a better solution to this
# problem we can remove this controller and routes.
class FaviconController < ApplicationController
  # Not a page a draft image could ever appear on - skip the Asset
  # Manager preflight redirect (see ApplicationController).
  skip_before_action :redirect_to_asset_manager_preflight_if_required

  before_action { expires_in(1.day, public: true) }

  def redirect_to_asset
    redirect_to(view_context.asset_path("favicon.ico"),
                status: :moved_permanently,
                allow_other_host: true)
  end
end
