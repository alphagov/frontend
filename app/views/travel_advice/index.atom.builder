atom_feed(:root_url => "https://www.gov.uk/travel-advice") do |feed|
  feed.title("Travel Advice Summary")
  feed.copyright("The Foreign and Commonwealth Office")
  @countries.each do |country|
    xml.entry do |entry|
      entry.title(country['name'])
      entry.link(:rel => "self", :type => "application/atom+xml",
                 :href => "https://www.gov.uk/travel-advice/#{country['identifier']}.atom")
      entry.updated(country['updated_at'])
    end
  end
end
