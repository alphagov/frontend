module HomepageHelper
  def organisations_json
    GdsApi.content_store.content_item("/government/organisations")
  end

  def ministerial_departments_count
    organisations_json
      .dig("details", "ordered_ministerial_departments")
      .filter { |org| org["govuk_status"] != "joining" }
      .count
  end

  def other_agencies_public_bodies_count
    organisations_json
      .dig("details", "ordered_agencies_and_other_public_bodies")
      .filter { |org| org["govuk_status"] != "joining" }
      .count
  end
end
