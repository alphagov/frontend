class HmrcManualPresenter < ContentItemPresenter
  include ManualMetadata

  def use_contextual_breadcrumbs?
    false
  end
end
