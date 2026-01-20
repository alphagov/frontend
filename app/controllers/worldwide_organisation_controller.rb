class WorldwideOrganisationController < ContentItemsController
  include Cacheable

  def show
    I18n.locale = @content_item.locale
    @presenter = WorldwideOrganisationPresenter.new(@content_item)
  end
end
