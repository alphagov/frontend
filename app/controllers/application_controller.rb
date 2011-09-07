require 'publisher_api'

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :api_host
  def api_host
    env = ENV['RAILS_ENV'] || 'development'
    case env 
    when 'development','test'
      "local.alphagov.co.uk:3000"
    when 'production'
       "api.alpha.gov.uk"
    else
       "guides.#{env}.alphagov.co.uk:8080"
    end
  end


  def api
    @api ||= PublisherApi.new("http://#{api_host}")
  end
end
