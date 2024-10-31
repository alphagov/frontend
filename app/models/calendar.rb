class Calendar
  REPOSITORY_PATH = "lib/data".freeze

  class CalendarNotFound < StandardError
  end

  def self.find(slug)
    json_file = Rails.root.join(REPOSITORY_PATH, "#{slug_to_scope(slug)}.json")
    if File.exist?(json_file)
      data = JSON.parse(File.read(json_file))
      new(slug, data)
    else
      raise CalendarNotFound
    end
  end

  def self.slug_to_scope(slug)
    slug == "gwyliau-banc" ? "bank-holidays" : slug
  end

  attr_reader :slug, :title, :scope, :description

  def initialize(slug, data = {})
    @slug = slug
    @data = data
    @title = I18n.t(data["title"])
    @description = I18n.t(data["description"])
    @scope = Calendar.slug_to_scope(slug)
  end

  def to_param
    slug
  end

  def divisions
    @divisions ||= @data["divisions"].map { |slug, data| Division.new(I18n.t(slug), data) }
  end

  def division(slug)
    div = divisions.find { |d| d.slug == slug }
    raise CalendarNotFound unless div

    div
  end

  def events
    divisions.map(&:events).flatten(1)
  end

  def show_bunting?
    divisions.any?(&:show_bunting?)
  end

  def bunting_styles
    if christmas? || new_year?
      "tinsel"
    else
      "triangles"
    end
  end

  def as_json(_options = nil)
    divisions.each_with_object({}) do |division, hash|
      hash[division.slug] = division.as_json
    end
  end

  def christmas?
    Time.zone.today.month == 12 && (25..28).include?(Time.zone.today.day)
  end

  def new_year?
    Time.zone.today.month == 1 && (1..4).include?(Time.zone.today.day)
  end
end
