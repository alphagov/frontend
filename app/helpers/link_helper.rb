module LinkHelper
  def feed_link(base_path)
    "#{base_path}.atom"
  end

  def print_link(base_path)
    "#{base_path}/print"
  end

  def share_links(base_path, title)
    [
      {
        href: facebook_share_url(base_path),
        text: "Facebook",
        icon: "facebook",
      },
    ]
  end

  def govuk_styled_link(text, path: nil, inverse: false)
    return text if path.blank?

    classes = "govuk-link"
    classes << " govuk-link--inverse" if inverse

    "<a href='#{path}' class='#{classes}'>".html_safe + text + "</a>".html_safe
  end

  def govuk_styled_links_list(links, inverse: false)
    links.map { |link| govuk_styled_link(link[:text], path: link[:path], inverse:) }
  end

private

  def facebook_share_url(base_path)
    "https://www.facebook.com/sharer/sharer.php?u=#{share_url(base_path)}"
  end

  def share_url(base_path)
    ERB::Util.url_encode(Plek.new.website_root + base_path)
  end
end
