require "slimmer/headers"

class HelpController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper

  before_filter :setup_slimmer_artefact
  before_filter :cache_headers
  before_filter :limit_to_html

  rescue_from AbstractController::ActionNotFound, :with => :error_404

  def index
  end

protected
  def setup_slimmer_artefact
    set_slimmer_dummy_artefact(:section_name => "Help", :section_link => "/help")
  end

  def cache_headers
    expires_in 10.minute, :public => true unless Rails.env.development?
  end
end



