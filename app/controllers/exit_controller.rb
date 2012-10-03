class ExitController < ApplicationController

  def exit
    error_404 and return unless (params[:slug] && params[:target] && params[:need_id])
    publication = fetch_publication(params)
    forwarding_warden = fetch_warden(publication)

    if forwarding_warden.nil?
      logger.info { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
      error_404 and return
    elsif not forwarding_warden.call(params[:target])
      logger.warn { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
      error 403 and return
    end

    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "no-cache, must-revalidate"
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true"

    redirect_to params[:target], :status => 302
  end

  protected
  def fetch_warden(publication)
    @redirect_warden_factory ||= RedirectWardenFactory.new
    @redirect_warden_factory.for(publication)
  end

end