class HomepageController < ApplicationController
  include EducationNavigationABTestable

  before_action :set_expiry

  def index
    set_slimmer_headers(
      template: "homepage",
      remove_search: true,
    )

    request.variant = :new_navigation if should_present_new_navigation_view?

    setup_content_item("/")

    render locals: { full_width: true }
  end

  def content_is_linked_to_a_taxon?
    true
  end
end
