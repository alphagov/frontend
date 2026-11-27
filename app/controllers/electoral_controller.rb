class ElectoralController < ContentItemsController
  include Cacheable

  BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE = "/contact-electoral-registration-office".freeze

  layout "header_content_sidebar"

  INVALID_POSTCODE = "invalidPostcodeFormat".freeze
  INVALID_UPRN = "invalidUprnFormat".freeze

  def show
    @content_item_presenter = LocalTransactionPresenter.new(content_item)
    return render :index unless params[:postcode] || params[:uprn]

    set_postcode_or_uprn

    elections_api.make_request

    if elections_api.ok?
      @presenter = ElectoralPresenter.new(elections_api.body)

      if @presenter.show_picker?
        render :address_picker and return
      end

      render :results
    else
      @location_error = LocationError.new(elections_api.error)
      render :index
    end
  rescue Postcode::InvalidPostcodeError
    @location_error = LocationError.new(INVALID_POSTCODE)
    render :index
  rescue Uprn::InvalidUprnError
    @location_error = LocationError.new(INVALID_UPRN)
    render :index
  end

private

  def content_item_path
    BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE
  end

  def set_postcode_or_uprn
    if params[:uprn]
      @uprn = Uprn.new(params[:uprn])
    else
      @postcode = Postcode.new(params[:postcode])
    end
  end

  def elections_api
    @elections_api ||= if @postcode.present?
                         ElectoralService.new(postcode: @postcode.compressed)
                       else
                         ElectoralService.new(uprn: @uprn.to_s)
                       end
  end
end
