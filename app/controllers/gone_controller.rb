class GoneController < ContentItemsController
  include Cacheable

  skip_before_action :reroute_to_gone

  def show
    head :gone
  end
end
