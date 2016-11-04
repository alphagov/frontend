class CampaignController < ApplicationController
  before_filter :set_expiry
  before_filter :fill_in_slimmer_headers

  def uk_welcomes
  end

  def fill_in_slimmer_headers
    set_slimmer_headers(
      format: "campaign",
    )
  end
end
