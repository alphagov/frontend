class ContentStoreController < RootController

  def content_store_test
    base_path = "/test-for-content-store/#{params[:path]}"
    item = content_store.content_item(base_path)
    if item
      @publication = ContentItemPresenter.new(item)
      render item.format
    else
      error_404
    end
  end

  private

  def content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"))
  end
end

