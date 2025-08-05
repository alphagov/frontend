class Publication < ContentItem
  include EmphasisedOrganisations
  include People
  include Updatable

  def contributors
    (organisations_ordered_by_emphasis + people).uniq
  end

  def dataset?
    %w[national_statistics official_statistics transparency].include? document_type
  end
end
