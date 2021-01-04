class ErrorController < ApplicationController
  def handler
    # defer any errors to be handled in ApplicationController
    raise request.env[:content_item_error]
  end
end
