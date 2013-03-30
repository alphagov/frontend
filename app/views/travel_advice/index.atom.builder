atom_feed(:root_url => travel_advice_url, :id => travel_advice_url) do |feed|
  feed.title("Travel Advice Summary")
  feed.updated(@publication.countries_by_date.first.updated_at)
  feed.author do |author|
    author.name "GOV.UK"
  end
  render :partial => 'country', :collection => @publication.countries_by_date.take(20), :locals => {:feed => feed}
end
