require 'publisher_api'
require 'imminence_api'

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :api_host
  def api_host
    env = ENV['RAILS_ENV'] || 'development'
    case env 
    when 'development','test'
      "publisher.dev.gov.uk"
    when 'production'
      "publisher.production.alphagov.co.uk"
    else
      "publisher.#{env}.alphagov.co.uk"
    end
  end

  helper_method :imminence_host
  def imminence_host
    env = ENV['RAILS_ENV'] || 'development'
    case env 
    when 'development','test'
      "imminence.dev.gov.uk"
    when 'production'
      "imminence.production.alphagov.co.uk"
    else
      "imminence.#{env}.alphagov.co.uk"
    end
  end


  helper_method :api
  def api
    @api ||= PublisherApi.new("http://#{api_host}")
  end

  helper_method :places_api
  def places_api
    @places_api ||= ImminenceApi.new("http://#{imminence_host}")
  end

end
