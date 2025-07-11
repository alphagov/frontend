module SinglePageNotificationButton
  extend ActiveSupport::Concern

  # Add the content id of the publication, detailed_guide or consultation that should be exempt from having the single page notification button
  EXEMPTION_LIST = %w[
    c5c8d3cd-0dc2-4ca3-8672-8ca0a6e92165
    a457220c-915c-4cb1-8e41-9191fba42540
  ].freeze

  def page_is_on_exemption_list?
    EXEMPTION_LIST.include? content_id
  end

  def display_single_page_notification_button?
    !page_is_on_exemption_list? && locale == "en"
  end
end
