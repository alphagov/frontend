class FatalityNoticeController < ContentItemsController
  include Cacheable

  def show
    @presenter = ContentItemPresenter.new(content_item)
  end

private

  def graphql_query_class
    Graphql::FatalityNoticeQuery
  end
end
