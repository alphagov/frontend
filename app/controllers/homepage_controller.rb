class HomepageController < ApplicationController
  before_filter :set_content_security_policy
  before_filter :set_expiry

  def index
    set_slimmer_headers(
      template: "homepage",
      format: "homepage",
      remove_search: true,
    )

    render locals: { full_width: true }
  end
end
