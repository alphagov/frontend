class DocumentCollection < ContentItem
  include Political
  include SinglePageNotificationButton
  include Updatable
  include Withdrawable

  def taxonomy_topic_email_override_base_path
    linked("taxonomy_topic_email_override").first&.base_path
  end
end
