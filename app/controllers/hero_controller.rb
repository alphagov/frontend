class HeroController < ApplicationController
  include Cacheable

  def show
    @content_item_presenter = HeroPresenter.new
  end
end
