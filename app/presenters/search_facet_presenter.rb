class SearchFacetPresenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  def initialize(facet, selected)
    @facet = facet
    @selected = selected
  end

  def to_hash
    {
      any?: @selected.any?,
      options: @facet["options"].map do |option|
        {
          slug: option['value']['slug'],
          title: option['value']['title'],
          count: number_with_delimiter(option['documents']),
          checked: option_checked(option)
        }
      end
    }
  end

private

  def option_checked(option)
    @selected.include?(option['value']['slug'])
  end
end
