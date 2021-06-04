class RoadmapController < ApplicationController
  include Cacheable

  def index
    render locals: { full_width: true }
  end
end
