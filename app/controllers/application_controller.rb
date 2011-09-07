require 'publisher_api'

class ApplicationController < ActionController::Base
  protect_from_forgery

  def api
    @api ||= PublisherApi.new("http://local.alphagov.co.uk:3000")
  end
end
