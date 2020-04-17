class ErrorController < ApplicationController
  def handler
    # defer any errors to be handled in ApplicationController
    raise request.env[:__api_error]
  end
end
