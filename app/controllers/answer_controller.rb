class AnswerController < ApplicationController
  include ApiRedirectable
  include Cacheable
  include Navigable

  def show
    set_content_item
  end
end
