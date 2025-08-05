class Publication < ContentItem
  include EmphasisedOrganisations
  include People
  include Updatable

  def dataset?
    %w[national_statistics official_statistics transparency].include? document_type
  end
end
