class HowGovernmentWorksController < ContentItemsController
  include Cacheable

  def show
    @presenter = HowGovernmentWorksPresenter.new(content_item)
  end
end
