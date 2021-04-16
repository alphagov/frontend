class ElectoralController < ApplicationController
  before_action -> { fetch_and_setup_content_item(BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE) }
  BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE = "/contact-electoral-registration-office".freeze

  def show
    @publication = LocalTransactionPresenter.new(@content_item)

    if no_input?
      render "local_transaction/search" and return
    end

    api_response =
      postcode_params ? fetch_response(postcode: postcode) : fetch_response(uprn: uprn_params)

    @presenter = presented_result(api_response)

    if indeterminate_postcode?
      render :address_picker and return
    end

    render :results
  end

private

  def no_input?
    postcode_params.nil? && uprn_params.nil?
  end

  def indeterminate_postcode?
    @presenter.address_picker
  end

  def fetch_response(postcode: nil, uprn: nil)
    endpoint = postcode ? "postcode/#{postcode_for_api}" : "address/#{uprn}"
    response = request_api("#{api_base_path}/#{endpoint}")
    JSON.parse(response)
  end

  def postcode_for_api
    postcode.gsub(/\s+/, "")
  end

  def postcode
    @postcode ||= PostcodeSanitizer.sanitize(postcode_params)
  end

  def postcode_params
    params[:postcode]
  end

  def uprn_params
    params[:uprn]
  end

  def presented_result(response)
    ElectoralPresenter.new(response)
  end

  def request_api(url)
    headers = {
      Authorization: "Token #{ENV['DEMOCRACY_CLUB_API_KEY']}",
    }
    RestClient.get(url, headers)
  end

  def api_base_path
    "https://api.ec-dc.club/api/v1"
  end
end
