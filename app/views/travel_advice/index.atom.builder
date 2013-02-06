atom_feed(:root_url => "#{request.scheme}://#{request.host}/travel-advice") do |feed|
  feed.title("Travel Advice Summary")
  feed.copyright("The Foreign and Commonwealth Office")
  @countries.each do |country|
    xml.entry do |entry|
      entry.title(country['name'])
      entry.link(:type => "application/atom+xml",
                 :href => "#{request.scheme}://#{request.host}/travel-advice/#{country['identifier']}.atom")
      entry.updated(country['updated_at'])
    end
  end
end
