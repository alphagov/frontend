# Because favicon has to be present at root, we need a controller
# to redirect it to the asset. When there's a better solution to this
# problem we can remove this controller and routes.
class FaviconController < ApplicationController
  before_action { expires_in(1.day, public: true) }

  def redirect_to_asset
    redirect_to(view_context.asset_path("favicon.ico"),
                status: :moved_permanently,
                allow_other_host: true)
  end
end
