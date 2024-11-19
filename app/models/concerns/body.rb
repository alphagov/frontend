module Body
  extend ActiveSupport::Concern

  def body
    content_store_hash.dig("details", "body")
  end
end
