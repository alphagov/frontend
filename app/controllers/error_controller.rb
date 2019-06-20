class ErrorController < ApplicationController
  slimmer_template 'wrapper'

  def handler
    # defer any errors to be handled in ApplicationController
    raise request.env[:__api_error]
  end
end
