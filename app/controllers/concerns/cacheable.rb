module Cacheable
  extend ActiveSupport::Concern

  included do
    before_filter -> { set_expiry unless viewing_draft_content? }
  end

  def viewing_draft_content?
    params.include?('edition')
  end
end
