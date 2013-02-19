module TravelAdviceHelper

  def group_by_initial_letter(countries)
    countries.group_by do |country|
      country['name'][0] if country and country['name']
    end
  end

  def readable_time(time)
    Time.parse(time).strftime("%e %B %Y")
  end
end
