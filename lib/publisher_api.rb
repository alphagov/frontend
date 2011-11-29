require 'net/http'
require 'ostruct'

require 'part_methods'
require 'json_utils'
require 'core-ext/openstruct'

class PublisherApi

  include JsonUtils

  def initialize(endpoint)
    @endpoint = endpoint
  end

  def base_url
    "#{@endpoint}/publications"
  end

  def url_for_slug(slug,options={})
    base = "#{base_url}/#{slug}.json"
    params = options.map { |k,v| "#{k}=#{v}" }
    base = base + "?#{params.join("&")}" unless options.empty? 
    base
  end

  def publications
    get_json(base_url) 
  end

  def publication_for_slug(slug,options = {})
    return nil if slug.blank?
    url = url_for_slug(slug,options)
    publication_hash = get_json(url)
    if publication_hash 
      container = to_ostruct(publication_hash)
      container.extend(PartMethods) if container.parts
      convert_updated_date(container)
      container
    else
      return nil
    end
  end
  
  def council_for_transaction(transaction,snac_codes)
    if json = post_json("#{@endpoint}/local_transactions/#{transaction.slug}/verify_snac.json",{'snac_codes' => snac_codes})
      return json['snac']
    else
      return nil
    end
  end
  
  protected
  def convert_updated_date(container)
    if container.updated_at && container.updated_at.class == String
      container.updated_at = Time.parse(container.updated_at)
    end
  end
end
