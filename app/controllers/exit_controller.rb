class ExitController < ApplicationController

  class TargetNotAllowed < StandardError
  end

  def exit
    raise RecordNotFound unless params[:slug] and params[:format]
    raise RecordNotFound unless params[:format] == 'transaction'

    publication = fetch_artefact

    raise RecordNotFound unless publication and publication.details and publication.details.link

    response.headers["Cache-Control"] = "public, max-age=0, s-maxage=1800"

    redirect_to publication.details.link, :status => 301
  rescue RecordNotFound
    logger.info { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
    statsd.increment('request.exit.404')
    error_404 and return
  end
end
