feed.entry(country,
           id: country.feed_id,
           url: country.web_url) do |entry|
  entry.title(country.title)
  entry.link(rel: "self", type: "application/atom+xml", href: "#{country.web_url}.atom")
  entry.summary(type: :xhtml) do |summary|
    summary << format_atom_change_description(country.change_description)
  end
end
