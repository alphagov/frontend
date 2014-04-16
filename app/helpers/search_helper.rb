module SearchHelper
  def show_tabs?(streams)
    streams.any?(&:anything_to_show?) || params[:organisation]
  end

  def display_organisations(organisations)
    organisations.map do |organisation|
      if organisation["acronym"] && (organisation["acronym"] != organisation["title"])
        content_tag("abbr", title: organisation["title"]) do
          organisation["acronym"]
        end
      else
        organisation["title"] || organisation["slug"]
      end
    end.join(", ").html_safe
  end

  def input_checked(value)
    if params['filter_organisations'] && params['filter_organisations'].include?(value)
      ' checked="checked"'
    elsif params['filter_organisations'] == value
      ' checked="checked"'
    end
  end

  def any_input_checked?
    params['filter_organisations']
  end

end
