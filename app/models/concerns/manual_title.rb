module ManualTitle
  extend ActiveSupport::Concern

  included do
    def title; end
  end
end
