xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title("Travel Advice Summary")
    xml.link("https://www.gov.uk/travel-advice/")
    xml.description()
    xml.copyright("The Foreign and Commonwealth Office")
    xml.language("en-gb")
    xml.ttl(1)
    xml.item do
      xml.title(@publication.title)
      xml.link("https://www.gov.uk/travel-advice/#{@publication.country['slug']}")
      xml.description(@publication.summary)
      xml.pubDate(@publication.updated_at)
      xml.guid(@publication.country['slug'])
    end
  end
end
