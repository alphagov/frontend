class CaseStudy < ContentItem
  include EmphasisedOrganisations
  include Updatable
  include WorldwideOrganisations

  def contributors
    contributors_list = (organisations_ordered_by_emphasis + worldwide_organisations).uniq
    super(contributors_list)
  end
end
