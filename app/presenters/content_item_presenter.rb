class ContentItemPresenter
  include LocaleHelper

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def breadcrumbs
    default_breadcrumbs
  end

  def contributor_links
    content_item.contributors.map do |content_item|
      { text: content_item.title, path: content_item.base_path }
    end
  end

  def default_breadcrumbs
    [
      {
        title: "Home",
        url: "/",
      },
    ]
  end

  def page_title_options
    {
      heading_text: content_item.title,
      context: content_item.context,
      context_locale: t_locale_fallback("formats.#{content_item.document_type}.name", default: nil, count: 1),
      page_text_direction: page_text_direction,
      lead_paragraph: content_item.lead_paragraph,
      translations: translations_for_nav(content_item.available_translations),
    }
  end
end
