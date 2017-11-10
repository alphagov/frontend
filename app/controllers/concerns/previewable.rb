module Previewable
  extend ActiveSupport::Concern

  included do
    before_filter :set_edition_for_viewing_draft_content
  end

  def set_edition_for_viewing_draft_content
    @edition = params[:edition]
  end

  def viewing_draft_content?
    params.include?('edition')
  end
end
