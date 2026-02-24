class WorldwideCorporateInformationPageController < ContentItemsController
  include Cacheable

  def show
    @presenter = WorldwideCorporateInformationPagePresenter.new(content_item)
  end
end
