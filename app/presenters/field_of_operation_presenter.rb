class FieldOfOperationPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def organisation
    org = @content_item.content_store_response.dig("links", "primary_publishing_organisation", 0)
    logo = org.dig("details", "logo")
    {
      name: logo["formatted_title"].html_safe,
      url: org["base_path"],
      brand: org.dig("details", "brand"),
      crest: logo["crest"],
    }
  end

  def description
    description = @content_item.description

    if description.present?
      description = description.html_safe
      if ActionController::Base.helpers.strip_tags(description).present?
        description
      end
    end
  end

  def contents
    contents = []
    contents << { href: "#field-of-operation", text: "Field of operation" } if description.present?
    contents << { href: "#fatalities", text: "Fatalities" } if @content_item.fatality_notices.present?

    contents
  end

  def roll_call_introduction(fatality_notice)
    fatality_notice.content_store_response.dig("details", "roll_call_introduction")
  end

  def casualties(fatality_notice)
    fatality_notice.content_store_response.dig("details", "casualties")
  end
end
