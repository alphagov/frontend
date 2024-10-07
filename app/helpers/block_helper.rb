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

  def column_class_for_equal_columns(number_of_columns)
    case number_of_columns
    when 1
      "govuk-grid-column"
    when 2
      "govuk-grid-column-one-half"
    when 3
      "govuk-grid-column-one-third"
    else
      "govuk-grid-column-one-quarter"
    end
  end
end
