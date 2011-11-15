require 'publisher_api'
require 'imminence_api'

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :api_host
  def api_host
    Plek.current.find('publisher')
  end

  helper_method :imminence_host
  def imminence_host
    Plek.current.find('data')
  end

  helper_method :api
  def api
    @api ||= PublisherApi.new(api_host)
  end

  helper_method :places_api
  def places_api
    @places_api ||= ImminenceApi.new(imminence_host)
  end

end
