class ErrorController < ApplicationController
  slimmer_template "core_layout"

  def handler
    # defer any errors to be handled in ApplicationController
    raise request.env[:__api_error]
  end
end
