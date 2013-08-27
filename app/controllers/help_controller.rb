require "slimmer/headers"

class HelpController < ApplicationController
  before_filter :setup_slimmer_artefact
  before_filter :set_expiry

  def index
  end

protected
  def setup_slimmer_artefact
    set_slimmer_dummy_artefact(:section_name => "Help", :section_link => "/help")
    set_slimmer_headers(format: 'help_page')
  end
end
