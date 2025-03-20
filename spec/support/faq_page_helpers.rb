module FaqPageHelper
  def find_structured_data(page, schema_name)
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    schemas.detect { |schema| schema["@type"] == schema_name }
  end
end
