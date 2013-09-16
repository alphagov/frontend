require "slimmer/headers"

class CampaignController < ApplicationController

  before_filter :setup_slimmer_artefact
  before_filter :set_expiry, :except => [:royal_mail_shares]

  def unimoney
  end

  def workplace_pensions
  end

  def uk_welcomes
  end

  def sort_my_tax
  end

  def new_licence_rules
  end

  def fire_kills
  end

  def know_before_you_go
  end

  def britain_is_great
  end

  ROYAL_MAIL_SHARES_START = Time.zone.parse("2013-09-12T07:00:00+01:00")
  # This campaign has to be live on this date, and not before
  def royal_mail_shares
    if Time.zone.now < ROYAL_MAIL_SHARES_START and ! params[:show_me_the_page]
      error_404
    else
      set_expiry
    end
  end

protected
  def setup_slimmer_artefact
    set_slimmer_headers(format: 'campaign')
  end

end
