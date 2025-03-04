class NewsArticle < ContentItem
  include EmphasisedOrganisations
  include People
  include Withdrawable
  include WorldwideOrganisations

  def contributors
    (organisations_ordered_by_emphasis + worldwide_organisations + people).uniq
  end
end
