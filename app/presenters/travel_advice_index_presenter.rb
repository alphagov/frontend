require 'ostruct'

class TravelAdviceIndexPresenter
  attr_accessor :countries, :description, :slug, :title, :subscription_url, :format

  def initialize(attributes)
    details = attributes.fetch("details")
    country_data = attributes.dig("links", "children")

    self.countries = country_data.map { |d| IndexCountry.new(d) }
    self.countries = countries_sorted_utf8
    self.description = attributes.fetch("description")
    self.slug = attributes.fetch("base_path")[1..-1]
    self.title = attributes.fetch("title")
    self.subscription_url = details.fetch("email_signup_link")
    self.format = "travel_advice"
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
      base_path = attributes.fetch("base_path")

      updated_at = attributes["public_updated_at"]
      updated_at = DateTime.parse(updated_at) if updated_at

      self.change_description = attributes.fetch("change_description")
      self.name = attributes.dig("country", "name")
      self.synonyms = attributes.dig("country", "synonyms")
      self.web_url =  [Frontend.govuk_website_root, base_path].join
      self.identifier = base_path.split("/").last
      self.updated_at = updated_at
    end

  private

    alias_method :title, :name
  end

  private

  def countries_sorted_utf8
    countries.sort_by do |country|
      ActiveSupport::Inflector.transliterate country.name
    end
  end
end
