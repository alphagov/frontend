module LinkHelper
  def govuk_styled_link(text, path: nil, inverse: false)
    return text if path.blank?

    classes = "govuk-link"
    classes << " govuk-link--inverse" if inverse

    "<a href='#{path}' class='#{classes}'>#{text}</a>".html_safe
  end

  def govuk_styled_links_list(links)
    links.map { |link| govuk_styled_link(link["title"], path: link["base_path"]) }
  end
end
