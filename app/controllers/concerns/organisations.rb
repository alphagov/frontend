module Organisations
  class << self
    def api
      # GdsApi::Organisations.new(Plek.new.website_root)
      GdsApi::Organisations.new("http://www.gov.uk")
    end

    def all_organisations
      api.organisations.with_subsequent_pages
    end

    def agencies_or_other_public_bodies
      orgs_with_allowed_govuk_status = filter_by_allowed_govuk_status(all_organisations)
      orgs_with_allowed_format = filter_by_allowed_format(orgs_with_allowed_govuk_status)
      filter_tribunals_with_parent_hm_courts_and_tribunals(orgs_with_allowed_format)
    end

  private

    # see
    # NB whilst Tribunal is on the list above it seems to be filtered out here:
    # https://github.com/alphagov/whitehall/blob/5cba22ae73efabd6e93f8da75b28a2ae88ffdec7/app/models/organisation/organisation_type_concern.rb#L59
    # https://github.com/alphagov/whitehall/blob/5cba22ae73efabd6e93f8da75b28a2ae88ffdec7/lib/publish_organisations_index_page.rb#L132
    def agency_or_public_body_format_allowlist
      [
        "Ad-hoc advisory group",
        "Advisory non-departmental public body",
        "Tribunal",
        "Executive agency",
        "Executive non-departmental public body",
        "Independent monitoring body",
        "Other",
      ]
    end

    def filter_by_allowed_format(organisations)
      organisations.select { |org| agency_or_public_body_format_allowlist.include?(org["format"]) }
    end

    # https://github.com/alphagov/whitehall/blob/5cba22ae73efabd6e93f8da75b28a2ae88ffdec7/lib/publish_organisations_index_page.rb#L132
    # https://github.com/alphagov/whitehall/blob/5cba22ae73efabd6e93f8da75b28a2ae88ffdec7/app/models/organisation/organisation_type_concern.rb#L24-L27
    # https://github.com/alphagov/whitehall/blob/5cba22ae73efabd6e93f8da75b28a2ae88ffdec7/app/models/organisation.rb#L259
    # Leaves:
    # ["live", "exempt", "joining", "closed", "devolved", "transitioning"]
    # only allow:
    # ["live", "exempt", "transitioning"]
    def filter_by_allowed_govuk_status(_organisations)
      allowed_status = %w[live exempt transitioning]
      all_organisations.select { |org| allowed_status.include?(org["details"]["govuk_status"]) }
    end

    ### But why!!!?
    # https://github.com/alphagov/whitehall/blob/5cba22ae73efabd6e93f8da75b28a2ae88ffdec7/app/models/organisation/organisation_type_concern.rb#L42-L56
    def filter_tribunals_with_parent_hm_courts_and_tribunals(organisations)
      organisations.reject do |org|
        org["format"] == "Tribunal" && org["parent_organisations"].pluck("id").any? { |id| id.ends_with?("hm-courts-and-tribunals-service") }
      end
    end
  end
end
