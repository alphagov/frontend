require "slimmer/headers"

class HelpController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include Slimmer::Headers
  
  before_filter :declare_section
  
  rescue_from AbstractController::ActionNotFound, :with => :error_404

  def index
  end
  
protected
  def declare_section
    @artefact = OpenStruct.new(section: 'Help')
  end

  def error_404
    error(404)
  end

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end
  
end



