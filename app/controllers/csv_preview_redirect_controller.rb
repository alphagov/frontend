class CsvPreviewRedirectController < ApplicationController
  before_action { expires_in(1.day, public: true) }

  def redirect
    csv_preview_path = "/csv-preview/#{params[:id]}/#{params[:filename]}"
    host = served_from_draft_asset_host? ? Plek.find("draft-origin", external: true) : Plek.find("www", external: true)

    redirect_to(host + csv_preview_path,
                status: :moved_permanently,
                allow_other_host: true)
  end

private

  def served_from_draft_asset_host?
    request.hostname == URI.parse(Plek.find("draft-assets")).hostname
  end
end
