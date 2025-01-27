module LinkHelper
  def feed_link(base_path)
    "#{base_path}.atom"
  end

  def print_link(base_path)
    "#{base_path}/print"
  end

  def govuk_styled_link(text, path: nil, inverse: false)
    return text if path.blank?

    classes = "govuk-link"
    classes << " govuk-link--inverse" if inverse

    "<a href='#{path}' class='#{classes}'>".html_safe + text + "</a>".html_safe
  end

  def govuk_styled_links_list(links)
    links.map { |link| govuk_styled_link(link["title"], path: link["base_path"]) }
  end
end
