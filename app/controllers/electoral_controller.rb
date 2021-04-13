class ElectoralController < ApplicationController
  def show
    @content_item = {
      title: "Elections lookup",
    }

    if postcode_params.nil?
      render
      return
    end

    @postcode = postcode_params.strip
    api_response = fetch_response(@postcode)
    @presented_result = presented_result(api_response)
    if @presented_result.address_picker
      render :address_picker, locals: { addresses: @presented_result.addresses }
      return
    end
    render :results
  end

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

private

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
