module Withdrawable
  extend ActiveSupport::Concern

  included do
    def withdrawn?
      withdrawal_notice.present?
    end

    def withdrawal_notice
      content_store_response["withdrawn_notice"]
    end

    def withdrawn_at
      withdrawal_notice["withdrawn_at"]
    end

    def withdrawn_explaination
      withdrawal_notice["explanation"]
    end
  end
end
