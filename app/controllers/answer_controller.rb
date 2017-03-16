class AnswerController < ApplicationController
  include Cacheable
  include Navigable
  include EducationNavigationABTestable

  def show
    set_content_item(AnswerPresenter)
  end
end
