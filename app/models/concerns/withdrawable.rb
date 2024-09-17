module Withdrawable
  extend ActiveSupport::Concern

  included do
    def withdrawn?
      withdrawal_notice.present?
    end
  end

private

  def withdrawal_notice
    content_store_response["withdrawn_notice"]
  end
end
