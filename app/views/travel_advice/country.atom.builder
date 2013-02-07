atom_feed(:root_url => @publication.web_url) do |feed|
  feed.title("Travel Advice Summary")
  feed.copyright("The Foreign and Commonwealth Office")
  xml.entry do |entry|
    entry.title(@publication.title)
    entry.link(:type => "text/html", :href => @publication.web_url)
    entry.summary(strip_tags(@publication.summary))
    entry.updated(@publication.updated_at)
  end
end
