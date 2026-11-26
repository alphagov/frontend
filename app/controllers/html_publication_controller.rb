class HtmlPublicationController < ContentItemsController
  include Cacheable

  def show
    # The chart component requires extra content security policy headers, so scope them to the specific page we're using only.
    if content_item.base_path == "/government/statistics/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025"
      policy = request.content_security_policy.clone
      policy.script_src(*policy.script_src, "'sha256-s5GmHtAbPP+QH98SnlbVlxAH9PivTpLxh6GfBUtFPQ8='", "'sha256-ZUgfKuVDhHkYm+2c77S3dJDwR2key233FxDgwcLOqN4='", "'sha256-qskLx5xxnbj1pBS/sIbXoiVEUJY7URMroNGznQ3H8Mo='", "'sha256-2KvOXLXgzlMUshwiHK/5zwEijAgkoCJFuCtzXspWesU='", "'sha256-GU0ikK9IXxFfiTqsEzMuos9mJA1/WEIyJixX2y/BhSQ='", "'sha256-PtEdqZPr1+KdAWzK6VhHropKzmwatOwFEjrLb/1zKik='", "'sha256-DbnaOuCDVn9dIOdh/shcK0yr/Tux2/hU2YTLtGA1HBM='", "'sha256-V/uIKFa5D0ymBvA0pC1tN+2xpKxWsQUgUbudmWNLjkE='", "'sha256-6wZ4yp29C1VpiJ/9YzF9/oT6xlRzQ/low9zJkhcRYW0='", :data)
      policy.style_src(*policy.style_src, "'unsafe-inline'")
      policy.style_src_attr(*policy.style_src_attr, "'unsafe-inline'")
      request.content_security_policy = policy
    end

    @presenter = HtmlPublicationPresenter.new(content_item)
  end
end
