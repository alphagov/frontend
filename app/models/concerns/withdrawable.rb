module Withdrawable
  extend ActiveSupport::Concern

  included do
    def withdrawn?
      withdrawal_notice.present?
    end

    def withdrawn_at
      withdrawal_notice["withdrawn_at"]
    end

    def withdrawn_explanation
      withdrawal_notice["explanation"]
    end
  end

private

  def withdrawal_notice
    content_store_response["withdrawn_notice"]
  end
end
