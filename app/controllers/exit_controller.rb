class ExitController < ApplicationController
  include PublicationHelper

  def exit
    error_404 and return unless (params[:slug] && params[:target] && params[:needId])
    publication = fetch_publication(params)
    forwarding_warden = fetch_warden(publication)

    if forwarding_warden.nil?
      logger.info { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
      error_404 and return
    elsif not forwarding_warden.call(params[:target])
      logger.warn { "root#exit rejected redirect to '#{params[:target]}' from #{params[:slug]}" }
      error 403 and return
    end

    gabba = create_gabba

    gabba.identify_user(cookies[:__utma])
    gabba.event(
        "MS_#{publication.type}", params[:needId], 'Success'
    )

    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "no-cache, must-revalidate"
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true"

    text = <<END_TEXT
<script>window.location.replace("#{params[:target]}")</script>
<noscript><META http-equiv="refresh" content="0;URL='#{params[:target]}'"></noscript>
END_TEXT
    render :text => text
  end

  protected
  def fetch_warden(publication)
    @redirect_warden_factory ||= RedirectWardenFactory.new
    @redirect_warden_factory.for(publication)
  end

  def create_gabba
    # track in google
    # WARNING! This is also set in static
    # todo: maybe use different domains - UA-26179049-1
    Gabba::Gabba.new("UA-33768939-1", ".www.gov.uk")
  end

end