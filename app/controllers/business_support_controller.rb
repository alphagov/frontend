class BusinessSupportController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable

  def show
    @publication = publication
    set_language_from_publication
  end
end
