class ElectoralController < ApplicationController
  before_action -> { fetch_and_setup_content_item(BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE) }
  BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE = "/contact-electoral-registration-office".freeze

  def show
    @publication = LocalTransactionPresenter.new(@content_item)

    if postcode_params.nil? && uprn_params.nil?
      render "local_transaction/search"
      return
    end

    if postcode_params && uprn_params
      @multiple_param_error = true
      render "local_transaction/search"
      return
    end

    @postcode = postcode if postcode_params
    @response = api_response_model

    if @response.bad_request?
      @bad_request_error = true
      render "local_transaction/search"
      return
    end

    @presenter = presented_result(@response.body)

    if @presenter.address_picker
      render :address_picker
      return
    end
    render :results
  end

private

  def raw_api_response
    endpoint = postcode ? "postcode/#{CGI.escape(postcode)}" : "address/#{uprn_params}"
    request_api("#{api_base_path}/#{endpoint}")
  end

  def api_response_model
    begin
      r = raw_api_response
      body = JSON.parse(r)
    rescue RestClient::BadRequest
      error = "bad_request"
    end
    DemocracyClubApiResponse.new(body, error)
  end

  def postcode_params
    params[:postcode]
  end

  def postcode
    PostcodeSanitizer.sanitize(postcode_params)
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
