class PerformanceController < ApplicationController
  include Cacheable

  def index
    setup_content_item("/performance")
  end

  def redirect_to_index
    redirect_to "/performance"
  end
end
