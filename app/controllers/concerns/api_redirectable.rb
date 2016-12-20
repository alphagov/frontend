module ApiRedirectable
  extend ActiveSupport::Concern

  included do
    before_filter :redirect_if_api_request
  end

  def redirect_if_api_request
    redirect_to "/api/#{slug_param}.json" if request.format.json? && request.get?
  end

  def slug_param
    params[:slug]
  end
end
