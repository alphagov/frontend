require 'ostruct'

class TravelAdviceIndexPresenter < PublicationPresenter
  class IndexCountry < OpenStruct
    def updated_at
      @updated_at ||= DateTime.parse(@table[:updated_at]) if @table[:updated_at]
    end
    def title
      self.name
    end
  end

  def wrapper_classes
    %w(travel-advice guide)
  end

  def countries
    @countries ||= details['countries'].map {|c| IndexCountry.new(c) }
  end

  def countries_by_date
    @countries_by_date ||= countries.sort do |a,b|
      b.updated_at <=> a.updated_at
    end
  end

  def countries_recently_updated
    countries_by_date.take(5)
  end
end
