module Navigable
  extend ActiveSupport::Concern

  included do
    before_action do
      if (content_item = request.env[:content_item])
        setup_content_item(content_item)
      else
        fetch_and_setup_content_item("/#{params[:slug]}")
      end
    end
  end
end
