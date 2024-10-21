class PlaceholderController < ApplicationController
  def show; end

private

  def content_item
    @content_item ||= ContentItemFactory.build_hardcoded
  end
end
