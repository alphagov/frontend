atom_feed(:root_url => "https://www.gov.uk/travel-advice/#{@publication.country['slug']}") do |feed|
  feed.title("Travel Advice Summary")
  feed.copyright("The Foreign and Commonwealth Office")
  xml.entry do |entry|
    entry.title(@publication.title)
    entry.link(:type => "text/html",
               :href => "#{request.scheme}://#{request.host}/travel-advice/#{@publication.country['slug']}")
    entry.summary(strip_tags(@publication.summary))
    entry.updated(@publication.updated_at)
  end
end
