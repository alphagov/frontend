class DocumentCollectionPresenter < ContentItemPresenter
  def show_email_signup_link?
    content_item.taxonomy_topic_email_override_base_path.present? && I18n.locale == :en
  end
end
