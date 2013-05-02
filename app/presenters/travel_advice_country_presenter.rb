require 'ostruct'

class TravelAdviceCountryPresenter < PublicationPresenter

  def image
    @image ||= OpenStruct.new(details["image"]) if details["image"]
  end

  def document
    @document ||= OpenStruct.new(details["document"]) if details["document"]
  end

  def country_name
    country['name']
  end

  def reviewed_at
    date = self.details["reviewed_at"]
    DateTime.parse(date) if date
  end

  def last_updated_or_reviewed_at
    reviewed_at || updated_at
  end
end
