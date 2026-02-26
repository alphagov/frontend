atom_feed(language: "en-GB", root_url:) do |feed|
  feed.title(title)

  feed.author do |author|
    author.name("HM Government")
  end

  feed.updated(items.first.updated) if items.any?

  items.each do |item|
    feed.entry(item, id: item.id, url: item.url, updated: item.updated) do |entry|
      entry.title(item.title)
      if item.display_type
        entry.category(label: item.display_type, term: item.display_type)
      end
      entry.summary(item.description)
    end
  end
end
