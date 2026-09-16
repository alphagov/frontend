module ImageCardHelper
  def grid_layout_options(item_count)
    {
      class: "govuk-grid-column-#{column_size(item_count)}",
      break_at_column: [1, 2, 4].include?(item_count) ? 2 : 3,
      large: (item_count == 1),
    }
  end

  def column_size(item_count)
    case item_count
    when 1
      "full"
    when 2 || 4
      "one-half"
    else
      "one-third"
    end
  end
end
