class HowGovernmentWorksController < ContentItemsController
  include Cacheable
  layout "header_content_sidebar"

  def show
    @content_item_presenter = HowGovernmentWorksPresenter.new(content_item)
  end
end
