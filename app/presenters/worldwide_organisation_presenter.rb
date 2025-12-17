class WorldwideOrganisationPresenter < ContentItemPresenter
  include WorldwideOrganisationBranding
  include ActionView::Helpers::UrlHelper

  WorldwideOffice = Struct.new(:contact, :has_access_and_opening_times?, :public_url, keyword_init: true)

  def formatted_title
    content_item.content_store_response["details"]["logo"]["formatted_title"]
  end

  def sponsoring_organisation_links
    return if sponsoring_organisations.empty?

    links = sponsoring_organisations.map do |organisation|
      link_to(organisation["title"], organisation["base_path"], class: "sponsoring-organisation govuk-link")
    end

    links.to_sentence.html_safe
  end

  def world_location_links
    return if world_locations.empty?

    world_location_name_translations = content_item.content_store_response["details"]["world_location_names"]

    links = world_locations.map do |location|
      world_location_translation = world_location_name_translations.find do |translation|
        translation["content_id"] == location["content_id"]
      end
      link_to(world_location_translation["name"], ::WorldLocationBasePathService.for(location), class: "govuk-link")
    end

    links.to_sentence.html_safe
  end

  def logo
    content_item.content_store_response["details"]["logo"] || []
  end

  def social_media_accounts
    content_item.content_store_response["details"]["social_media_links"] || []
  end

  def show_our_people_section?
    person_in_primary_role || people_in_non_primary_roles.any?
  end

  def person_in_primary_role
    return unless content_item.content_store_response["links"]["primary_role_person"]

    person = content_item.content_store_response["links"]["primary_role_person"].first
    current_roles = roles_for_person(person["content_id"])

    {
      name: person["title"],
      href: person["base_path"],
      image_url: person.dig("details", "image", "url"),
      image_alt: person.dig("details", "image", "alt_text"),
      description: presented_title_for_roles(current_roles),
    }
  end

  def people_in_non_primary_roles
    secondary_role_person = content_item.content_store_response["links"]["secondary_role_person"] || []
    office_staff = content_item.content_store_response["links"]["office_staff"] || []
    people = secondary_role_person + office_staff
    return [] unless people.any?

    people.map do |person|
      current_roles = roles_for_person(person["content_id"])

      {
        name: person["title"],
        href: person["base_path"],
        description: presented_title_for_roles(current_roles),
      }
    end
  end

  def main_office
    return unless (office_item = content_item.content_store_response["links"]["main_office"])&.first

    office_contact_item = contact_for_office(office_item["content_id"])
    return unless office_contact_item

    office(office_item, office_contact_item)
  end

  def home_page_offices
    return [] unless content_item.content_store_response["links"]["home_page_offices"]

    content_item.dig("links", "home_page_offices").map { |office|
      contact = contact_for_office(office["content_id"])
      next unless contact

      office(office, contact)
    }.compact
  end

  def sponsoring_organisations
    content_item.content_store_response["links"]["sponsoring_organisations"] || []
  end

private

  def office(office, contact)
    WorldwideOffice.new(
      contact: WorldwideOrganisation::LinkedContactPresenter.new(contact),
      has_access_and_opening_times?: office.dig("details", "access_and_opening_times").present?,
      public_url: office["base_path"],
    )
  end

  def contact_for_office(office_content_id)
    contact_mapping = content_item.dig("details", "office_contact_associations").select { |office_contact_association|
      office_contact_association["office_content_id"] == office_content_id
    }.first

    return unless contact_mapping

    content_item.dig("links", "contacts").select { |contact|
      contact["content_id"] == contact_mapping["contact_content_id"]
    }.first
  end

  def presented_title_for_roles(roles)
    roles
      .map { |role| role["title"] }
      .compact.join(", ")
  end

  def roles_for_person(person_content_id)
    content_item
    .content_store_response
    .dig("details", "people_role_associations")
    .select { |people_role_association| people_role_association["person_content_id"] == person_content_id }
    .first["role_appointments"]
    .pluck("role_content_id")
    .map { |role_content_id|
      content_item.content_store_response.dig("links", "roles").select do |role|
        role["content_id"] == role_content_id
      end
    }
    .flatten
  end

  def world_locations
    content_item.content_store_response["links"]["world_locations"] || []
  end
end
