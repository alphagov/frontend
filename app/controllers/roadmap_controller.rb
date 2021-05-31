class RoadmapController < ApplicationController
  include Cacheable

  def index
    slimmer_template "gem_layout"
  end
end
