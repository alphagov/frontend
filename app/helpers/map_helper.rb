module MapHelper
  def minimum_map_data?(config, markers, geojson)
    true if config[:centre_lat] && config[:centre_lng] && config[:zoom] || markers.any? || !geojson.nil?
  end
end
