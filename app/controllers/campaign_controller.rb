require "slimmer/headers"

class CampaignController < ApplicationController

  before_filter :setup_slimmer_artefact

  def energy_help
  end

  def workplace_pensions
  end

protected
  def setup_slimmer_artefact
    set_slimmer_headers(format: 'campaign')
  end

end
