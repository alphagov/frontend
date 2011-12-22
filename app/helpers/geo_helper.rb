require 'addressable/uri'

module GeoHelper
  def geo_known_to_at_least?(accuracy)
    options = ['point', 'postcode', 'postcode_district', 'ward', 'council', 'nation', 'country', 'planet']
    the_index = options.index(accuracy.to_s)
    geo_known_to?(*options.slice(0, the_index + 1))
  end

  def geo_known_to?(*accuracy)
    geo_header and geo_header['fuzzy_point'] and accuracy.include?(geo_header['fuzzy_point']['accuracy'])
  end
  
  def geo_friendly_name
    geo_header['friendly_name']
  end
  
  def district_postcode
    geo_header['postcode'] if geo_header['postcode'].present?
  end

  def geo_header
    #if request.env['HTTP_X_GOVGEO_STACK'] and request.env['HTTP_X_GOVGEO_STACK'] != ''
    #  @geo_header ||= JSON.parse(Base64.decode64(request.env['HTTP_X_GOVGEO_STACK']))
    #else
    #  @geo_header ||= {}
    #end
    @geo_header = {}
    @geo_header
  end
  
  def reset_geo_url
    callback = Addressable::URI.parse(request.url)
    callback.query_values = {:reset_geo => 'true'}
    return callback.to_s
  end
end
