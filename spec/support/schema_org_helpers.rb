module SchemaOrgHelpers
  def find_schemas
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schema_sections.map { |section| JSON.parse(section.text(:all)) }
  end

  def find_schema_of_type(schema_type)
    find_schemas.detect { |schema| schema["@type"] == schema_type }
  end
end
