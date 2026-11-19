class HtmlPublicationController < ContentItemsController
  include Cacheable
  def show
    # The chart component requires extra content security policy headers, so scope them to the specific page we're using only.
    if content_item.base_path == "/government/statistics/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025-technical-and-quality-assurance-report"
      policy = request.content_security_policy.clone
      policy.script_src(*policy.script_src, "'sha256-Na+neCEFq435MZueHH0naZt7a7f2cXIxdIxY3yjlSNI='", :data)
      policy.style_src_attr(*policy.style_src_attr, "'unsafe-inline'")
      request.content_security_policy = policy
    end

    @presenter = HtmlPublicationPresenter.new(content_item)
  end
end
