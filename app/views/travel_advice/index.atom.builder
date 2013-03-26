atom_feed(:root_url => travel_advice_url) do |feed|
  feed.title("Travel Advice Summary")
  feed.updated(DateTime.parse(@publication.countries_by_date.first['updated_at']))
  feed.author do |author|
    author.name "GOV.UK"
  end
  @publication.countries_by_date.take(20).each do |country|
    feed.entry(country,
               :id => "#{country['web_url']}##{country['updated_at']}",
               :url => country['web_url']) do |entry|
      entry.title(country['name'])
      entry.link(:rel => "self", :type => "application/atom+xml", :href => "#{country['web_url']}.atom")
      entry.updated(country['updated_at'])
      entry.summary(:type => :xhtml) do |summary|
        summary << numericise_html_entities(country['change_description'])
      end
    end
  end
end
