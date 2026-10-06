class RecentPresenter
  def initialize(results)
    @results = results
  end

  def formatted_results
    @results.map do |result|
      {
        link: {
          text: result[:link][:text],
          path: result[:link][:path],
          description: result[:metadata][:description],
        },
        metadata: result[:metadata].except(:display_type, :description),
      }
    end
  end
end
