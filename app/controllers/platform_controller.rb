require "slimmer/headers"

class PlatformController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include Slimmer::Headers

  before_filter :declare_section
  before_filter :cache_headers

  rescue_from AbstractController::ActionNotFound, :with => :error_404

  def index
  end

protected
  def declare_section
    @artefact = OpenStruct.new(section: 'Platform')
  end

  def cache_headers
    expires_in 10.minute, :public => true unless Rails.env.development?
  end

  def error_404
    error(404)
  end

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end

end
