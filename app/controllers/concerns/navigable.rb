module Navigable
  extend ActiveSupport::Concern

  included do
    before_action -> { fetch_and_setup_content_item("/#{slug_param}") }
  end

  def slug_param
    params[:slug]
  end
end
