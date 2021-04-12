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
    render :results
  end

  def fetch_response(_postcode)
    path = Rails.root.join("test/fixtures/electoral-result.json")
    fixture = File.read(path)
    JSON.parse(fixture)
  end

  def postcode_params
    params[:postcode]
  end

  def presented_result(response)
    ElectoralPresenter.new(response)
  end
end
