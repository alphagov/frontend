module TravelAdviceHelper

  def group_by_initial_letter(countries)
    countries.group_by {|c| c['name'][0] if c and c['name'] }
  end

end
