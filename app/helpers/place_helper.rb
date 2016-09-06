module PlaceHelper
  def track_category_for_place_results(places)
    places.any? ? "postcodeSearch:place" : "userAlerts:place"
  end

  def track_action_for_place_results(places)
    places.any? ? "postcodeResultShown" : "postcodeErrorShown:validPostcodeNoLocation"
  end

  def track_label_for_place_results(places)
    places.any? ? places.first["name"] : "We couldn't find any results for this postcode."
  end
end
