require 'net/http'
require 'ostruct'

require 'part_methods'

class PublisherApi

  def initialize(endpoint)
    @endpoint = endpoint
  end

  def base_url
    "#{@endpoint}/publications"
  end

  def url_for_slug(slug,options={})
    base = "#{base_url}/#{slug}.json"
    params = options.map { |k,v| "#{k}=#{v}" }
    base = base + "?#{params.join("")}" unless options.empty? 
    base
  end

  def fetch_json(url)
    url = URI.parse(url)
    response = Net::HTTP.start(url.host, url.port) do |http|
      request = url.path
      request = request + "?" + url.query if url.query
      http.get(request)
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
      container.extend(PartMethods)
    end
  end

  def publication_for_slug(slug,options = {})
    return nil if slug.blank?
    url = url_for_slug(slug,options)
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

  def council_for_transaction(transaction,snac_codes)
    url = URI.parse("#{@endpoint}/local_transactions/#{transaction.slug}/verify_snac.json")
    Net::HTTP.start(url.host, url.port) do |http|
      post_response = http.post(url.path, {'snac_codes' => snac_codes}.to_json, {'Content-Type' => 'application/json'})
      if post_response.code == '200'
        return JSON.parse(post_response.body)['snac']
      end
    end
    return nil
  end
end
