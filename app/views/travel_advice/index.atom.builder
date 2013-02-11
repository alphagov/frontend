atom_feed(:root_url => "https://www.gov.uk/travel-advice") do |feed|
  feed.title("Travel Advice Summary")
  feed.updated(@countries.map {|c| DateTime.parse(c['updated_at']) }.max)
  feed.author do |author|
    author.name "GOV.UK"
  end
  @countries.each do |country|
    feed.entry(country,
               :id => "tag:www.gov.uk,2005:/travel-advice/#{country['identifier']}/#{country['updated_at']}",
               :url => country['web_url']) do |entry|
      entry.title(country['name'])
      entry.link(:rel => "self", :type => "application/atom+xml", :href => "#{country['web_url']}.atom")
      entry.updated(country['updated_at'])
      entry.summary "Coming soon"
    end
  end
end
