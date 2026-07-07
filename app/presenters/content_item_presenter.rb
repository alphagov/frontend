class ContentItemPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def breadcrumb_options
    default_breadcrumb_options
  end

  def contributor_links
    content_item.contributors.map do |content_item|
      { text: content_item.title, path: content_item.base_path }
    end
  end

  def default_breadcrumb_options
    {
      collapse_on_mobile: true,
      breadcrumbs: [
        {
          title: "Home",
          url: "/",
        },
      ],
      margin_bottom: 5,
    }
  end
end
