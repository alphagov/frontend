require 'gds_api/publisher'
require 'gds_api/imminence'
require 'gds_api/panopticon'

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :api
  def api
    @api ||= GdsApi::Publisher.new(Rails.env)
  end

  helper_method :places_api
  def places_api
    @places_api ||= GdsApi::Imminence.new(Rails.env)
  end

  helper_method :artefact_api
  def artefact_api
    @artefact_api ||= GdsApi::Panopticon.new(Rails.env)
  end
end
