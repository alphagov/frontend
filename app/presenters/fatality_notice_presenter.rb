class FatalityNoticePresenter < ContentItemPresenter
  include LinkHelper
  include DateHelper

  def page_title_options
    super.merge({
      metadata: {
        from: govuk_styled_links_list(contributor_links),
        first_published: display_date(content_item.initial_publication_date),
        last_updated: display_date(content_item.updated),
      },
    })
  end
end
