module PlaceHelper
  def track_category_for_place_results(places)
    places.any? ? "postcodeSearch:place" : "userAlerts:place"
  end

  def track_action_for_place_results(places)
    places.any? ? "postcodeResultShown" : "postcodeErrorShown:noResults"
  end

  def track_label_for_place_results(places)
    places.any? ? places.first["name"] : "Sorry, no results were found near you."
  end
end
