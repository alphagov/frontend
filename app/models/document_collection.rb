class DocumentCollection < ContentItem
  include Political
  include Updatable

  def taxonomy_topic_email_override_base_path
    linked("taxonomy_topic_email_override").first&.base_path
  end
end
