class ExitController < ApplicationController

  class TargetNotAllowed < StandardError
  end

  def exit
    raise RecordNotFound unless params[:slug] and params[:format]
    raise RecordNotFound unless params[:format] == 'transaction'

    publication = fetch_artefact

    raise RecordNotFound unless publication and publication.details and publication.details.link

    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "no-cache, must-revalidate"

    redirect_to publication.details.link, :status => 302
  rescue RecordNotFound
    logger.info { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
    statsd.increment('request.exit.404')
    error_404 and return
  end
end
