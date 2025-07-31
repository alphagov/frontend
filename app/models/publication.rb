class Publication < ContentItem
  DATASETS = %w[national_statistics official_statistics transparency].freeze

  def dataset?
    DATASETS.include? document_type
  end
end
