class TravelAdviceController < ApplicationController
  FOREIGN_TRAVEL_ADVICE_SLUG = "foreign-travel-advice".freeze

  def index
    set_expiry
    fetch_and_setup_content_item("/" + FOREIGN_TRAVEL_ADVICE_SLUG)
    @presenter = TravelAdviceIndexPresenter.new(@content_item)

    respond_to do |format|
      format.html do
        slimmer_template "gem_layout"
      end
      format.atom do
        set_expiry(5.minutes)
        headers["Access-Control-Allow-Origin"] = "*"
      end
    end
  end
end
