module CampaignHelper
  def campaign_image_url(publication, size)
    if image_attrs = publication.details["#{size}_image"]
      image_attrs['web_url']
    end
  end

  def formatted_organisation_name(publication)
    organisation_name = organisation_attr(publication, 'formatted_name') || ""
    ERB::Util.html_escape(organisation_name).strip.gsub(/(?:\r?\n)/, "<br/>").html_safe
  end

  def organisation_url(publication)
    organisation_attr(publication, 'url')
  end

  def organisation_crest(publication)
    organisation_attr(publication, 'crest')
  end

  def organisation_brand_colour(publication)
    organisation_attr(publication, 'brand_colour')
  end

private
  
  def organisation_attr(publication, attr_name)
    if org_attrs = publication.details['organisation']
      org_attrs[attr_name]
    end
  end
end
