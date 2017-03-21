module Cacheable
  extend ActiveSupport::Concern

  included do
    before_filter -> { set_expiry }
  end
end
