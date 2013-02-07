atom_feed(:root_url => @publication.web_url) do |feed|
  feed.title("Travel Advice Summary")
  feed.updated @publication.updated_at
  feed.author do |author|
    author.name "GOV.UK"
  end
  feed.entry(@publication,
              :id => "tag:www.gov.uk,2005:/travel-advice/#{@publication.country['slug']}/#{@publication.updated_at}",
              :url => @publication.web_url) do |entry|
    entry.title(@publication.title)
    entry.summary(strip_tags(@publication.summary))
  end
end
