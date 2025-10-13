class WebchatController < ContentItemsController
  include Cacheable

  def show; end

  content_security_policy do |p|
    p.connect_src(*p.connect_src, -> { content_item.csp_connect_src })
  end

private

  def set_content_item_and_cache_control
    loader_response = ContentItemLoader.for_request(request).load(content_item_path)
    raise loader_response if loader_response.is_a?(StandardError)

    @content_item = Webchat.new(loader_response.to_hash)
    @cache_control = loader_response.cache_control
  end
end
