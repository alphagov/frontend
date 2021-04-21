class ElectoralController < ApplicationController
  before_action -> { fetch_and_setup_content_item(BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE) }
  BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE = "/contact-electoral-registration-office".freeze

  def show
    @publication = LocalTransactionPresenter.new(@content_item)

    if valid_postcode? || valid_uprn?
      @presenter = presented_result(fetch_response)

      if indeterminate_postcode?
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
                end

    LocationError.new(error_key) if error_key.present?
  end

  def indeterminate_postcode?
    @presenter.address_picker
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

  def fetch_response
    endpoint = postcode.present? ? "postcode/#{postcode.postcode_for_api}" : "address/#{uprn.sanitized_uprn}"
    response = request_api("#{api_base_path}/#{endpoint}")
    JSON.parse(response)
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

  def request_api(url)
    headers = {
      Authorization: "Token #{ENV['ELECTIONS_API_KEY']}",
    }
    RestClient.get(url, headers)
  end

  def api_base_path
    ENV["ELECTIONS_API_URL"]
  end
end
