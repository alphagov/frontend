class LatestController < ApplicationController
  def latest_page
    # Redirect to the most recent published GOV.UK page.
    query = {
      reject_format: "recommended-link", # excludes external content
      fields: "link",
      order: "-public_timestamp",
      count: 1,
    }

    result = GdsApi.search.search(query)["results"].first["link"]

    expires_in(5.seconds, public: true)
    redirect_to Frontend.govuk_website_root + result, allow_other_host: true
  end
end
