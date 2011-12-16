require 'gds_api/helpers'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GdsApi::Helpers
end
