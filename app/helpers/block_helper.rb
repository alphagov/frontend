module BlockHelper
  def render_block(block, options: {})
    render("landing_page/blocks/#{block.type}", block:, options:)
  rescue ActionView::MissingTemplate
    Rails.logger.warn("Missing template for block #{block.type}")
    ""
  end

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

  def column_class_for_assymetric_columns(number_of_columns, column_size)
    case number_of_columns
    when 3
      case column_size
      when 1
        "govuk-grid-column-one-third"
      when 2
        "govuk-grid-column-two-thirds-from-desktop"
      end
    when 4
      case column_size
      when 1
        "govuk-grid-column-one-quarter"
      when 2
        "govuk-grid-column-two-quarters"
      when 3
        "govuk-grid-column-three-quarters"
      end
    end
  end
end
