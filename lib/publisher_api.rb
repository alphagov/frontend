require 'part_methods'
require 'gds_api'

class PublisherApi < GdsApi

  def publications
    get_json(base_url) 
  end

  def publication_for_slug(slug,options = {})
    return nil if slug.blank?
    
    publication_hash = get_json(url_for_slug(slug, options))
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
  
  private
    def convert_updated_date(container)
      if container.updated_at && container.updated_at.class == String
        container.updated_at = Time.parse(container.updated_at)
      end
    end
    
    def base_url
      "#{@endpoint}/publications"
    end
end
