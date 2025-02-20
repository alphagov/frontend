class CaseStudy < ContentItem
  include Updatable
  include WorldwideOrganisations
  include Organisations

  def contributors
    contributors_list = (organisations_ordered_by_emphasis + worldwide_organisations).uniq
    super(contributors_list)
  end
end
