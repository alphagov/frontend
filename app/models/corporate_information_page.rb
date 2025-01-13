class CorporateInformationPage < ContentItem
  def organisation_logo(organisation = default_organisation)
    return nil unless organisation && organisation.dig("details", "logo")

    logo = organisation["details"]["logo"]
    logo_component_params = {
      organisation: {
        name: logo["formatted_title"].html_safe,
        url: organisation["base_path"],
        brand: organisation_brand(organisation),
        crest: logo["crest"],
      },
    }

    if logo["image"]
      logo_component_params[:organisation][:image] = {
        url: logo["image"]["url"],
        alt_text: logo["image"]["alt_text"],
      }
    end

    logo_component_params
  end

  def organisation_brand_class(organisation = default_organisation)
    organisation_brand(organisation).present? ? "#{organisation_brand(organisation)}-brand-colour" : nil
  end

  def default_organisation
    organisation_content_id = content_store_response.dig("details", "organisation")
    organisation = nil

    if organisations.present?
      organisation = organisations.detect { |org| org["content_id"] == organisation_content_id }
    end

    organisation
  end

private

  # HACK: Replaces the organisation_brand for executive office organisations.
  # Remove this in the future after migrating organisations to the content store API,
  # and updating them with the correct brand in the actual store.
  def organisation_brand(organisation)
    return unless organisation

    brand = organisation.dig("details", "brand")
    brand = "executive-office" if executive_order_crest?(organisation)
    brand
  end

  def executive_order_crest?(organisation)
    organisation.dig("details", "logo", "crest") == "eo"
  end
end
