module FlexiblePage::FlexibleSection
  class Featured < Base
    def items
      flexible_section_hash["items"]
    end

    def grid_layout_options
      one_item = {
        class: "govuk-grid-column-full",
        break_at_column: 2,
        large: true,
      }
      two_or_four_items = {
        class: "govuk-grid-column-one-half",
        break_at_column: 2,
      }

      number_of_featured_items = items.length

      return one_item if number_of_featured_items == 1
      return two_or_four_items if [2, 4].include?(number_of_featured_items)

      {
        class: "govuk-grid-column-one-third",
        break_at_column: 3,
      }
    end
  end
end
