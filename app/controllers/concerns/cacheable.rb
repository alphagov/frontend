module Cacheable
  extend ActiveSupport::Concern

  included do
    before_action :set_expiry, if: -> { request.format.html? }
  end
end
