class DetailedGuidePresenter < ContentItemPresenter
  include ContentsList
  include DateHelper
  include LinkHelper

  PATHS_TO_HIDE = %w[
    /guidance/about-govuk-chat
    /guidance/govuk-chat-terms-and-conditions
  ].freeze

  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      metadata: {
        from: govuk_styled_links_list(contributor_links),
        first_published: display_date(content_item.first_public_at || content_item.first_published_at),
        last_updated: display_date(content_item.updated),
        see_updates_link: true,
      },
      logo: logo,
    })
  end

  def logo
    return unless content_item.image

    { path: content_item.image["url"], alt_text: "European structural investment funds" }
  end

  def hide_from_search_engines?
    PATHS_TO_HIDE.include?(content_item.base_path)
  end
end
