module PlaceHelper
  def preposition_for_place_list(place_list)
    return I18n.t("format.places.prepositions.near") unless place_list.any?

    place_list.first["gss"].blank? ? I18n.t("format.places.prepositions.near") : I18n.t("format.places.prepositions.for")
  end
end
