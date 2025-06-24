class ServiceListPresenter
  def items_for_document_list
    I18n.t("help.sign_in.service_list_items").each_with_index.map do |item, index|
      {
        link: {
          text: item[:text],
          path: item[:path],
          description: item[:description],
          full_size_description: true,
          data_attributes: {
            module: "gem-track-click",
            track_category: "DocumentListClicked",
            track_action: "1.#{index}",
            track_label: item[:path],
          },
        },
      }
    end
  end
end
