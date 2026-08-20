class WorldwideOrganisationController < ContentItemsController
  include Cacheable

  layout "header_content_sidebar"

  def show
    I18n.locale = @content_item.locale
    @content_item_presenter = WorldwideOrganisationPresenter.new(@content_item)
  end
end
