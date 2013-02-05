atom_feed("xml:lang" => "en-GB", "xmlns" => "http://www.w3.org/2005/Atom", :encoding => "UTF-8") do |feed|
  feed.title("Travel Advice Summary")
  feed.link(:rel => "self", :type => "application/rss+xml",
           :href => "https://www.gov.uk/travel-advice.rss")
  feed.link(:rel => "alternate", :type => "text/html",
           :href => "https://www.gov.uk/travel-advice")
  feed.copyright("The Foreign and Commonwealth Office")
  xml.entry do |entry|
    entry.title(@publication.title)
    entry.link(:rel => "self", :type => "application/rss+xml",
             :href => "https://www.gov.uk/travel-advice/#{@publication.country['slug']}.rss")
    entry.link(:rel => "alternate", :type => "text/html",
             :href => "https://www.gov.uk/travel-advice/#{@publication.country['slug']}")
    entry.summary(strip_tags(@publication.summary))
    entry.updated(@publication.updated_at)
  end
end
