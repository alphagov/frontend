class WebchatController < ContentItemsController
  include Cacheable

  def show; end

  content_security_policy do |p|
    p.connect_src(*p.connect_src, -> { content_item.csp_connect_src })
  end
end
