class GetInvolvedController < ContentItemsController
  def show
    @content_item_presenter = GetInvolvedPresenter.new(@content_item)
    render layout: "header_content_sidebar"
  end

private

  def set_content_item_and_cache_control
    loader_response = ContentItemLoader.for_request(request).load(content_item_path)
    raise loader_response if loader_response.is_a?(StandardError)

    @content_item = GetInvolved.new(loader_response.to_hash)
    @cache_control = loader_response.cache_control
  end
end
