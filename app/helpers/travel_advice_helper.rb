require "htmlentities"

module TravelAdviceHelper
  def format_atom_change_description(text)
    # Encode basic entities([<>&'"]) as named, the rest as decimal
    simple_format(HTMLEntities.new.encode(text, :basic, :decimal))
  end
end
