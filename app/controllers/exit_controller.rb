class ExitController < ApplicationController

  class TargetNotAllowed < StandardError
  end

  def exit
    raise RecordNotFound unless params_valid?(params)
    publication = fetch_artefact
    raise RecordNotFound unless publication
    if params[:target]
      if publication.raw_response_body.include?(params[:target])
        target = params[:target]
      else
        raise TargetNotAllowed
      end
    else
      target = publication.details.link
    end

    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "no-cache, must-revalidate"

    redirect_to target, :status => 302
  rescue RecordNotFound
    logger.info { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
    statsd.increment('request.exit.404')
    error_404 and return
  rescue TargetNotAllowed
    logger.warn { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
    statsd.increment('request.exit.403')
    error 403 and return
  end

  protected
  def params_valid?(params)
    if params[:slug].nil? || params[:need_id].nil?
      false
    elsif params[:target].nil? and params[:format] != 'transaction'
      false
    elsif params[:target] and not params[:target] =~ URI::regexp
      false
    else
      true
    end
  end
end
