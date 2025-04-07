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
    description = @content_item["description"]

    description.html_safe if description.present?
  end

  def contents
    contents = []
    contents << { href: "#field-of-operation", text: "Field of operation" } if description.present?
    contents << { href: "#fatalities", text: "Fatalities" } if fatality_notices.present?

    contents
  end
end
