module Cacheable
  extend ActiveSupport::Concern

  included do
    before_action -> { set_expiry }
  end
end
