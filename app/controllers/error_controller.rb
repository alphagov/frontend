class ErrorController < ApplicationController
  # Already handling an error - skip the Asset Manager preflight
  # redirect (see ApplicationController) rather than delaying it further.
  skip_before_action :redirect_to_asset_manager_preflight_if_required

  def handler
    # We know at this point that the ContentItemLoader has stored
    # an exception to deal with, so just retrieve it and raise it
    # to be handled in ApplicationController
    raise ContentItemLoader.for_request(request).load(request.path)
  end
end
