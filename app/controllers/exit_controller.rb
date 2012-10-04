class ExitController < ApplicationController

  def exit
    publication = params_valid?(params) ? fetch_publication(params) : nil
    if publication.nil?
      logger.info { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
      statsd.increment('request.exist.404')
      error_404 and return
    elsif not publication.marshal_dump.to_json.include?(params[:target])
      logger.warn { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
      statsd.increment('request.exist.403')
      error 403 and return
    end

    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "no-cache, must-revalidate"

    redirect_to params[:target], :status => 302
  end

  protected
  def fetch_warden(publication)
    @redirect_warden_factory ||= RedirectWardenFactory.new
    @redirect_warden_factory.for(publication)
  end

  # Initialise statsd
  def statsd
    @statsd ||= Statsd.new("localhost").tap do |c|
      c.namespace = "govuk.app.frontend"
    end
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