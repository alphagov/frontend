class TravelAdviceIndexPresenter < PublicationPresenter

  def wrapper_classes
    %w(travel-advice guide)
  end

  def countries
    details['countries']
  end

  def countries_by_date
    @countries_by_date ||= countries.sort do |a,b|
      b['updated_at'] <=> a['updated_at']
    end
  end

  def countries_recently_updated
    countries_by_date.take(5)
  end
end
