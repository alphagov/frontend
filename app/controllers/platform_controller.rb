require "slimmer/headers"

class PlatformController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include Slimmer::Headers

  def index
    @slug = params[:slug]
    
    if @slug
      path = File.expand_path("../../views/platform/_#{@slug}.html.erb", __FILE__)
      error 404 unless File.exists?(path)  
    end
    
    set_slimmer_headers(
      section:     "platform"
    )
  end
  
  protected
    def error(status_code)
      render status: status_code, text: "#{status_code} error"
    end
  
end