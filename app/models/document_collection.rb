class DocumentCollection < ContentItem
  include Updatable

  def show_email_signup_link?
    false
  end

  def display_single_page_notification_button?
    true
  end
end
