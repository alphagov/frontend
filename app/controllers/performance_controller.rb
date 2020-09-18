class PerformanceController < ApplicationController
  include Cacheable

  def index
    setup_content_item("/performance")
  end
end
