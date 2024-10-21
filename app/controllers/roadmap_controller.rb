class RoadmapController < ApplicationController
  include Cacheable

  def index; end

private

  def content_item
    @content_item ||= ContentItemFactory.build_hardcoded
  end
end
