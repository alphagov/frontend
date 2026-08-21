class WorldwideCorporateInformationPageController < ContentItemsController
  include Cacheable

  def show
    @presenter = WorldwideCorporateInformationPagePresenter.new(content_item)
    render layout: "header_content_sidebar"
  end
end
