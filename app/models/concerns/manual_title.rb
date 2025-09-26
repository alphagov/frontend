module ManualTitle
  extend ActiveSupport::Concern

  included do
    def title
      content_store_response["links"]["manual"].first["title"]
    end
  end
end
