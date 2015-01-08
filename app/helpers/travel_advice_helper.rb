require 'htmlentities'

module TravelAdviceHelper

  def group_by_initial_letter(countries)
    countries.group_by do |country|
      country.name[0] if country and country.name
    end
  end

  def format_atom_change_description(text)
    # Encode basic entities([<>&'"]) as named, the rest as decimal
    simple_format(HTMLEntities.new.encode(text, :basic, :decimal))
  end
end
