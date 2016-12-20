class VideoController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable

  before_filter :set_publication

  def show
  end
end
