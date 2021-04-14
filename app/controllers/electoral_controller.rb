class ElectoralController < ApplicationController
  before_action -> { fetch_and_setup_content_item(BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE) }
  BASE_PATH_OF_EXISTING_CONTACT_LOCAL_ERO_SERVICE = "/contact-electoral-registration-office".freeze

  def show
    @publication = LocalTransactionPresenter.new(@content_item)

    if postcode_params.nil?
      render "local_transaction/search"
      return
    end

    @postcode = postcode_params.strip
    api_response = fetch_response(@postcode)
    @presented_result = presented_result(api_response)
    render :results
  end

private

  def fetch_response(postcode)
    response = request_api("#{api_base_path}/postcode/#{postcode}")
    JSON.parse(response)
  end

  def postcode_params
    params[:postcode]
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
