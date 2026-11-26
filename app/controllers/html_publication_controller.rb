class HtmlPublicationController < ContentItemsController
  include Cacheable

  def show
    # The chart component requires extra content security policy headers, so scope them to the specific page we're using only.
    if content_item.base_path == "/government/statistics/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025"
      policy = request.content_security_policy.clone
      policy.script_src(*policy.script_src, "'sha256-s5GmHtAbPP+QH98SnlbVlxAH9PivTpLxh6GfBUtFPQ8='", "'sha256-ZUgfKuVDhHkYm+2c77S3dJDwR2key233FxDgwcLOqN4='", "'sha256-/GfinjiAuYtt1WIdnExBRO8OEkBvCN//CbH2aga18Kk='", :data)
      policy.style_src(*policy.style_src, "'unsafe-inline'")
      policy.style_src_attr(*policy.style_src_attr, "'unsafe-inline'")
      request.content_security_policy = policy
    end

    @presenter = HtmlPublicationPresenter.new(content_item)
  end
end
