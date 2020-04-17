class TravelAdviceController < ApplicationController
  FOREIGN_TRAVEL_ADVICE_SLUG = "foreign-travel-advice".freeze

  slimmer_template "core_layout"

  def index
    set_expiry
    setup_content_item("/" + FOREIGN_TRAVEL_ADVICE_SLUG)
    @presenter = TravelAdviceIndexPresenter.new(@content_item)

    respond_to do |format|
      format.html { render locals: { full_width: true } }
      format.atom do
        set_expiry(5.minutes)
        headers["Access-Control-Allow-Origin"] = "*"
      end
    end
  end
end
