class ServiceManualServiceStandardPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def breadcrumbs
    [
      { title: "Service manual", url: "/service-manual" },
    ]
  end

  def body
    @content_item.content_store_response.dig("details", "body").html_safe
  end

  def email_alert_signup_link
    "/email-signup?link=#{@content_item.base_path}"
  end

  def show_default_breadcrumbs?
    false
  end
end
