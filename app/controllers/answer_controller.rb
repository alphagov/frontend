class AnswerController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable
  include EducationNavigationABTestable

  before_filter :set_publication

  def show
  end
end
