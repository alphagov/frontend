module MetadataFormatHelper
  def format_for_metadata_component(metadata)
    formatted_metadata = {}
    metadata.each do |k, v|
      formatted_value = case v[:type]
                        when "date"
                          display_date(v[:value])
                        when "link"
                          govuk_styled_links_list(v[:value])
                        else
                          v[:value]
                        end

      formatted_metadata[k] = formatted_value
    end

    formatted_metadata
  end
end
