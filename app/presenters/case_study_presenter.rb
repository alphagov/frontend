class CaseStudyPresenter < ContentItemPresenter
  include LinkHelper
  include DateHelper

  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      metadata: {
        from: govuk_styled_links_list(contributor_links),
        first_published: display_date(content_item.initial_publication_date),
        last_updated: display_date(content_item.updated),
        page_history: formatted_history(content_item.history),
      },
    })
  end
end
