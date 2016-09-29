require 'htmlentities'

module TravelAdviceHelper
  def group_by_initial_letter(countries)
    groups = countries.group_by do |country|
      country.name[0] if country and country.name
    end

    groups.sort_by { |name, _| name }
  end

  def format_atom_change_description(text)
    # Encode basic entities([<>&'"]) as named, the rest as decimal
    simple_format(HTMLEntities.new.encode(text, :basic, :decimal))
  end
end
