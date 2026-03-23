module MapHelper
  def minimum_map_data?(config, markers)
    true if config[:centre_lat] && config[:centre_lng] && config[:zoom] || markers.any?
  end
end
