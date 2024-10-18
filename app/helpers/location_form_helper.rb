module LocationFormHelper
  def button_text(publication_format = nil)
    case publication_format
    when "local_transaction", "licence"
      I18n.t("formats.local_transaction.find_council")
    else
      I18n.t("find")
    end
  end
end
