class HowGovernmentWorksController < ContentItemsController
  include Cacheable

  def show
    @content_item_presenter = HowGovernmentWorksPresenter.new(content_item)
  end
end
