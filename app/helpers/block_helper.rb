module BlockHelper
  def tab_items_to_component_format(tab_items)
    tab_items.map do |ti|
      {
        id: ti["id"],
        label: ti["label"],
        content: sanitize("<p class=\"govuk-body-m\">#{ti['content']}</p>"),
      }
    end
  end
end
