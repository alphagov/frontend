class CaseStudy < ContentItem
  include EmphasisedOrganisations
  include Updatable
  include WorldwideOrganisations

  def contributors
    (organisations_ordered_by_emphasis + worldwide_organisations).uniq(&:content_id)
  end
end
