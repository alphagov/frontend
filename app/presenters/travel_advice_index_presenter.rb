require 'ostruct'

class TravelAdviceIndexPresenter
  attr_accessor :countries, :description, :slug, :title, :subscription_url, :format

  def initialize(attributes)
    details = attributes.fetch("details")
    country_data = details.fetch("countries")

    self.countries = country_data.map { |d| IndexCountry.new(d) }
    self.description = attributes.fetch("description")
    self.slug = attributes.fetch("base_path")[1..-1]
    self.title = attributes.fetch("title")
    self.subscription_url = details.fetch("email_signup_link")
    self.format = "travel-advice"
  end

  def countries_by_date
    @countries_by_date ||= countries.sort do |a, b|
      b.updated_at <=> a.updated_at
    end
  end

  def countries_recently_updated
    countries_by_date.take(5)
  end

  class IndexCountry
    attr_accessor :change_description, :name, :synonyms, :updated_at, :web_url, :identifier

    def initialize(attributes)
      self.change_description = attributes.fetch("change_description")
      self.name = attributes.fetch("name")
      self.synonyms = attributes.fetch("synonyms")
      self.web_url = attributes.fetch("base_path")
      self.identifier = web_url.split("/").last

      updated_at = attributes["updated_at"]
      updated_at = DateTime.parse(updated_at) if updated_at

      self.updated_at = updated_at
    end

    alias_method :title, :name
  end
end
