module FlexiblePage::FlexibleSection
  class Featured < Base
    attr_reader :items

    def initialize(items:, ga4_image_card_json: nil)
      super

      @ga4_image_card_json = ga4_image_card_json
      @items = items
    end

    def ga4_tracking(index_link = nil, index_total = nil)
      return nil unless @ga4_image_card_json

      if index_link && index_total
        index_obj = { index: { index_link: index_link }, index_total: index_total }
        @ga4_image_card_json.merge!(index_obj)
      end

      {
        module: "ga4-link-tracker",
        ga4_link: @ga4_image_card_json.to_json,
      }
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
