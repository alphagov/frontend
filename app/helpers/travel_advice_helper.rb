module TravelAdviceHelper

  def group_by_initial_letter(countries)
    countries.group_by {|c| c['name'][0] if c and c['name'] }
  end

  def readable_time(time)
    time.strftime("%e %B %Y")
  end
end
