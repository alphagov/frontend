feed.entry(country,
           :id => "#{country.web_url}##{country.updated_at}",
           :url => country.web_url) do |entry|
  entry.title(country.title)
  entry.link(:rel => "self", :type => "application/atom+xml", :href => "#{country.web_url}.atom")
  entry.summary(:type => :xhtml) do |summary|
    summary << format_atom_change_description(country.change_description)
  end
end
