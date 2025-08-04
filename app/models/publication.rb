class Publication < ContentItem
  def dataset?
    %w[national_statistics official_statistics transparency].include? document_type
  end
end
