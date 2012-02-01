require "slimmer/headers"

class FeedbackController < ApplicationController
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
    @artefact = OpenStruct.new(section: 'Feedback')
  end

  def cache_headers
    expires_in 10.minute, :public => true unless Rails.env.development?
  end
end



