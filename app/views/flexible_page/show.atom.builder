atom_feed(root_url: canonical_url(content_item.base_path), id: canonical_url(content_item.base_path)) do |feed|
  feed.title(content_item.title)
  feed.updated Time.zone.parse(content_item.public_updated_at)
  feed.link(rel: "self", type: "application/atom+xml", href: "#{canonical_url(content_item.base_path)}.atom")
  feed.link(rel: "alternate", type: "text/html", href: canonical_url(content_item.base_path))
  feed.author do |author|
    author.name "GOV.UK"
  end

  content_item.feed_items.each do |feed_item|
    url = canonical_url(feed_item[:link][:path])
    updated = feed_item[:metadata][:public_updated_at]
    id = "#{url}##{updated}"

    feed.entry(feed_item, id:, url:, updated:) do |entry|
      entry.link(rel: "alternate", type: "text/html", href: url)
      entry.title(feed_item[:link][:text])
    end
  end
end
