require 'gds_api'

class ImminenceApi < GdsApi
  def api_url(type,lat,lon,limit=5)
    "#{@endpoint}/places/#{type}.json?limit=#{limit}&lat=#{lat}&lng=#{lon}"
  end

  def places(type,lat,lon,limit=5)
    places = get_json(api_url(type,lat,lon,limit)) || []
    places.map do |o|
      o['latitude'] = o['location'][0]
      o['longitude'] = o['location'][1]
      o['address'] = [o['address1'], o['address2']].reject { |a| a.nil? or a == '' }.map { |a| a.strip }.join(', ')
      o
    end
  end

end
