class HomepageController < ContentItemsController
  include Cacheable

  slimmer_template "gem_layout_homepage"

  def index
    set_slimmer_headers(template: "gem_layout_homepage_new")
  end

private

  def search_component
    if show_search_autocomplete?
      "search_with_autocomplete"
    else
      "search"
    end
  end
  helper_method :search_component

  def publication_class
    Homepage
  end

  def show_search_autocomplete?
    true unless ENV["GOVUK_DISABLE_SEARCH_AUTOCOMPLETE"]
  end
end
