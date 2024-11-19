module Withdrawable
    extend ActiveSupport::Concern
  
    included do
      def withdrawn?
        withdrawal_notice.present?
      end
  
      def withdrawal_notice
        content_store_hash["withdrawn_notice"]
      end
    end
  end