class TravelAdviceController < ContentItemsController
  include Cacheable

  FOREIGN_TRAVEL_ADVICE_PATH = "/foreign-travel-advice".freeze

  def index
    @presenter = TravelAdviceIndexPresenter.new(content_item.to_h)

    respond_to do |format|
      format.html
      format.atom do
        set_expiry(5.minutes)
        headers["Access-Control-Allow-Origin"] = "*"
      end
    end
  end

  def show
    content_item.set_current_part(params[:slug])

    redirect_to content_item.base_path if content_item.current_part.blank?

    @travel_advice_presenter = TravelAdvicePresenter.new(content_item)

    request.variant = :print if params[:variant] == :print

    respond_to do |format|
      format.html
      format.atom
    end
  end

private

  def content_item_path
    return FOREIGN_TRAVEL_ADVICE_PATH if request.path.split(".").first == FOREIGN_TRAVEL_ADVICE_PATH

    "#{FOREIGN_TRAVEL_ADVICE_PATH}/#{params[:country]}"
  end
end
