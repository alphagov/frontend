require 'net/http'
require 'ostruct'

require 'parts'

class PublisherApi

  def initialize(endpoint)
    @endpoint = endpoint
  end

  def base_url
    "#{@endpoint}/publications"
  end

  def url_for_slug(slug)
    "#{base_url}/#{slug}.json"
  end

  def fetch_json(url)
    url = URI.parse(url)
    response = Net::HTTP.start(url.host, url.port) do |http|
      http.get(url.path)
    end
    if response.code.to_i != 200
      return nil
    else
      return JSON.parse(response.body)
    end
  end

  def publications
    fetch_json(base_url) 
  end

  def parse_updated_at(container)
    if container.updated_at && container.updated_at.class == String
      container.updated_at = Time.parse(container.updated_at)
    end
  end

  def reinflate_parts(container)
    if container.parts
      container.parts = container.parts.map {|h| OpenStruct.new(h)}
      container.extend(Parts)
    end
  end

  def publication_for_slug(slug)
    return nil if slug.blank?
    url = url_for_slug(slug)
    publication_hash = fetch_json(url)
    if publication_hash
      container = OpenStruct.new(publication_hash)
      parse_updated_at(container)
      reinflate_parts(container)
      container
    else
      return nil
    end
  end
end
