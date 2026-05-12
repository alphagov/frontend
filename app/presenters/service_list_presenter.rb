class ServiceListPresenter
  def items_for_document_list
    I18n.t("help.sign_in.service_list_items").each.map do |item|
      {
        link: {
          text: item[:text],
          path: item[:path],
          description: item[:description],
          full_size_description: true,
        },
      }
    end
  end
end
