module SearchHelper
  def show_tabs?(streams)
    streams.any?(&:anything_to_show?) || params[:organisation]
  end

  def display_organisations(organisations)
    organisations.map do |organisation|
      if organisation["acronym"] && (organisation["acronym"] != organisation["title"])
        title_without_acronym = organisation_title_without_acronym(organisation["title"])
        content_tag("abbr", title: title_without_acronym) do
          organisation["acronym"]
        end
      else
        organisation["title"] || organisation["slug"]
      end
    end.join(", ").html_safe
  end

  def organisation_title_without_acronym(raw_title)
    # This regex extracts the last term in brackets as the "acronym" group;
    # the remainder matches as the title, except the separating space.
    #
    # For example, "Ministry of Defence (MOD)" matches with:
    #
    #     "title" => "Ministry of Defence"
    #     "acronym" => "MOD"
    #
    # Note that a title with multiple parenthesised suffixes will only match
    # the last one. For example, "Forest Enterprise (England) (FEE)" becomes:
    #
    #     "title" => "Forest Enterprise (England)"
    #     "acronym" => "FEE"
    merged_pattern = %r{\A(?<title>.+) \((?<acronym>[^)]+)\)\Z}
    pattern_match = merged_pattern.match(raw_title)
    if pattern_match
      pattern_match["title"]
    else
      raw_title
    end
  end
end
