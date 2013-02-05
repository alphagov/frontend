xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title("Travel Advice Summary")
    xml.link(:rel => "self", :type => "application/rss+xml",
             :href => "https://www.gov.uk/travel-advice.rss")
    xml.link(:rel => "alternate", :type => "text/html",
             :href => "https://www.gov.uk/travel-advice")
    xml.description("Travel Advice Summary for #{@publication.country['name']}")
    xml.copyright("The Foreign and Commonwealth Office")
    xml.language("en-gb")
    xml.ttl(1)
    xml.item do
      xml.title(@publication.title)
      xml.link(:rel => "self", :type => "application/rss+xml",
               :href => "https://www.gov.uk/travel-advice/#{@publication.country['slug']}.rss")
      xml.link(:rel => "alternate", :type => "text/html",
               :href => "https://www.gov.uk/travel-advice/#{@publication.country['slug']}")
      xml.description(@publication.summary)
      xml.pubDate(@publication.updated_at)
      xml.guid(@publication.country['slug'])
    end
  end
end
