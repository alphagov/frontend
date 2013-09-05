require "slimmer/headers"

class HelpController < ApplicationController
  before_filter :setup_slimmer_artefact
  before_filter :set_expiry

  def index
    respond_to do |format|
      format.html
      format.json { redirect_to "/api/help.json" }
    end
  end

protected
  def setup_slimmer_artefact
    @artefact = fetch_artefact
    set_slimmer_artefact(@artefact)
    set_slimmer_headers(format: 'help_page')
  end

  def fetch_artefact
    ArtefactRetriever.new(content_api, Rails.logger, statsd, ['custom-application']).
      fetch_artefact('help')
  end
end
