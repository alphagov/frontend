module TravelAdviceHelper

  def group_by_initial_letter(countries)
    countries.sort do |x, y|
      x['name'] <=> y['name']
    end.group_by do |country|
      country['name'][0] if country and country['name']
    end
  end

  def readable_time(time)
    time.strftime("%e %B %Y")
  end
end
