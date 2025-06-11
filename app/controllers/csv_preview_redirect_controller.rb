class CsvPreviewRedirectController < ApplicationController
  before_action { expires_in(1.day, public: true) }

  def redirect
    host = if served_from_draft_asset_host?
             # PLEK_HOSTNAME_PREFIX is set on draft environments,
             # which means a 'draft-' prefix will be added to this host
             Plek.find("origin", external: true)
           else
             Plek.website_root
           end

    redirect_to(host + "/csv-preview/#{params[:id]}/#{params[:filename]}",
                status: :moved_permanently,
                allow_other_host: true)
  end

private

  def served_from_draft_asset_host?
    request.hostname == URI.parse(Plek.find("draft-assets")).hostname
  end
end
