require 'gds_api/helpers'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers

  def error_404; error 404; end
  def error_500; error 500; end
  def error_501; error 501; end
  def error_503; error 503; end

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end
end
