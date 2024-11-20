class TravelAdviceController < ContentItemsController
  include Cacheable

  FOREIGN_TRAVEL_ADVICE_SLUG = "foreign-travel-advice".freeze

  def index
    @presenter = TravelAdviceIndexPresenter.new(content_item_hash)

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

private

  # TODO: Controllers should provide a presenter or a publication.
  # These objects duplicate roles (see `presenter || @publication`) in views.
  def publication; end

  def content_item_path
    "/#{FOREIGN_TRAVEL_ADVICE_SLUG}"
  end
end
