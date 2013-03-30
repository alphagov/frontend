atom_feed(:root_url => @publication.web_url, :id => @publication.web_url) do |feed|
  feed.title("Travel Advice Summary")
  feed.updated @publication.updated_at
  feed.author do |author|
    author.name "GOV.UK"
  end
  render :partial => 'country', :object => @publication, :locals => {:feed => feed}
end
