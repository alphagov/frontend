class CaseStudy < ContentItem
  include Updatable
  include WorldwideOrganisations
  include Organisations

  def contributors
    (organisations_ordered_by_emphasis + worldwide_organisations).uniq
  end
end
