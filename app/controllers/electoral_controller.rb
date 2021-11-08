class ElectoralController < ApplicationController
  before_action -> { fetch_and_setup_content_item(BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE) }
  BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE = "/contact-electoral-registration-office".freeze

  def show
    @publication = LocalTransactionPresenter.new(@content_item)

    elections_api.make_request if valid_postcode? || valid_uprn?

    if elections_api.ok?
      @presenter = presented_result(elections_api.body)

      if @presenter.show_picker?
        render :address_picker and return
      end

      render :results
    else
      @location_error = location_error
      render "local_transaction/search"
    end
  end

private

  def location_error
    error_key = if invalid_postcode?
                  postcode.error
                elsif invalid_uprn?
                  uprn.error
                elsif elections_api.error?
                  elections_api.error
                end

    LocationError.new(error_key) if error_key.present?
  end

  def valid_postcode?
    postcode.present? && postcode.valid?
  end

  def invalid_postcode?
    postcode.present? && !postcode.valid?
  end

  def valid_uprn?
    uprn.present? && uprn.valid?
  end

  def invalid_uprn?
    uprn.present? && !uprn.valid?
  end

  def elections_api
    @elections_api ||= if postcode.present?
                         ElectoralService.new(postcode: postcode.postcode_for_api)
                       else
                         ElectoralService.new(uprn: uprn.sanitized_uprn)
                       end
  end

  def postcode
    @postcode ||= ElectionPostcode.new(postcode_params)
  end

  def postcode_params
    params[:postcode]
  end

  def uprn
    @uprn || Uprn.new(uprn_params)
  end

  def uprn_params
    params[:uprn]
  end

  def presented_result(response)
    ElectoralPresenter.new(response)
  end
end
