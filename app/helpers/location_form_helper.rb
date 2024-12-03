module LocationFormHelper
  def button_text(publication_format = nil, publication_title = nil)
    case publication_format
    when "local_transaction", "licence"
      I18n.t("formats.local_transaction.find_council")
    when "place"
      places_button_text(publication_title)
    else
      I18n.t("find")
    end
  end

  def places_button_text(publication_title)
    publications_where_button_text_matches_title = ["Find a register office", "Darganfod swyddfa gofrestru"]
    publications_where_button_text_matches_title.include?(publication_title) ? publication_title : I18n.t("formats.place.find_results")
  end
end
