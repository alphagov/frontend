class CsvPreviewRedirectController < ApplicationController
  before_action { expires_in(1.day, public: true) }

  def redirect
    host = served_from_draft_asset_host? ? Plek.find("draft-origin", external: true) : Plek.find("www", external: true)

    redirect_to(host + "/csv-preview/#{params[:id]}/#{params[:filename]}",
                status: :moved_permanently,
                allow_other_host: true)
  end

private

  def served_from_draft_asset_host?
    request.hostname == URI.parse(Plek.find("draft-assets")).hostname
  end
end
