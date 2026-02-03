class ManualSectionPresenter < ContentItemPresenter
  include ManualMetadata

  MOJ_ORGANISATION_CONTENT_ID = "dcc907d6-433c-42df-9ffb-d9c68be5dc4d".freeze

  def show_contents_list?
    content_item.organisations.first.content_id == MOJ_ORGANISATION_CONTENT_ID
  end
end
