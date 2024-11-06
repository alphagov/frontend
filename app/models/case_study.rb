class CaseStudy < ContentItem
  include Updatable
  include WorldwideOrganisations

  def related_entities
    (linkable_organisations + worldwide_organisations).uniq
  end
end
