class ExitController < ApplicationController

  class TargetNotAllowed < StandardError
  end

  def exit
    raise RecordNotFound unless params_valid?(params)
    publication = fetch_artefact
    raise RecordNotFound unless publication
    raise TargetNotAllowed unless publication.raw_response_body.include?(params[:target])

    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "no-cache, must-revalidate"

    redirect_to params[:target], :status => 302
  rescue RecordNotFound
    logger.info { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
    statsd.increment('request.exist.404')
    error_404 and return
  rescue TargetNotAllowed
    logger.warn { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
    statsd.increment('request.exist.403')
    error 403 and return
  end

  protected
  def fetch_warden(publication)
    @redirect_warden_factory ||= RedirectWardenFactory.new
    @redirect_warden_factory.for(publication)
  end

  def params_valid?(params)
    if params[:slug].nil? || params[:target].nil? || params[:need_id].nil?
      false
    elsif not params[:target] =~ URI::regexp
      false
    else
      true
    end
  end
end
