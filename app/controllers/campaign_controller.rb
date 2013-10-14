require "slimmer/headers"

class CampaignController < ApplicationController

  before_filter :setup_slimmer_artefact
  before_filter :set_expiry

  def uk_welcomes
  end

protected
  def setup_slimmer_artefact
    set_slimmer_headers(format: 'campaign')
  end

end
