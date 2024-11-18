module NationalApplicability
  extend ActiveSupport::Concern

  included do
    def national_applicability
      content_store_response["details"]["national_applicability"]&.deep_symbolize_keys
    end
  end
end
