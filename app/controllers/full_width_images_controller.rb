class FullWidthImagesController < ApplicationController
  slimmer_template "gem_layout_full_width"

  include Cacheable

  def index; end
end
