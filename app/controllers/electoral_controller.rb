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
    @api_response = fetch_response(@postcode)
    render :results
  end

private

  def fetch_response(_postcode)
    path = Rails.root.join("test/fixtures/electoral-result.json")
    fixture = File.read(path)
    JSON.parse(fixture)
  end

  def postcode_params
    params[:postcode]
  end
end
