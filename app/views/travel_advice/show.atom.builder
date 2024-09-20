atom_feed(root_url: canonical_url(@content_item.base_path), id: canonical_url(@content_item.base_path)) do |feed|
  feed.title("Travel Advice Summary")
  feed.updated @content_item.atom_public_updated_at
  feed.author do |author|
    author.name "GOV.UK"
  end
  feed.entry(@content_item, id: "#{canonical_url(@content_item.base_path)}##{@content_item.atom_public_updated_at}", url: canonical_url(@content_item.base_path), updated: @content_item.atom_public_updated_at) do |entry|
    entry.title(@content_item.title)
    entry.link(rel: "self", type: "application/atom+xml", href: "#{canonical_url(@content_item.base_path)}.atom")
    entry.summary(type: :xhtml) do |summary|
      summary << format_atom_change_description(@content_item.change_description)
    end
  end
end
