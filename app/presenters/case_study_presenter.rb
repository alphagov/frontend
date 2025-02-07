class CaseStudyPresenter < ContentItemPresenter
  include HasHistory

  def initialize(content_item, view_context = nil)
    super(content_item)

    @view_context = view_context
  end

private

  attr_reader :view_context
end
