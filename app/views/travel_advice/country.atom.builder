atom_feed(:root_url => @publication.web_url) do |feed|
  feed.title("Travel Advice Summary")
  feed.updated @publication.updated_at
  feed.author do |author|
    author.name "GOV.UK"
  end
  feed.entry(@publication,
              :id => "#{@publication.web_url}##{@publication.updated_at}",
              :url => @publication.web_url) do |entry|
    entry.title(@publication.title)
    entry.summary(:type => :xhtml) do |summary|
      summary << @publication.change_description
    end
  end
end
