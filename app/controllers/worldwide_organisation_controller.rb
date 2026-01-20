class WorldwideOrganisationController < ContentItemsController
  include Cacheable

  def show
    @presenter = WorldwideOrganisationPresenter.new(@content_item)
  end
end
