class LicenceDetails
  def from_artefact(artefact, licence_authority_slug, snac_code, interaction = nil)
    licence = artefact['details']['licence']
    licence_attributes = { licence: licence }

    return false if missing_or_invalid_licence?(licence)

    licence_attributes[:authority] = authority_for_licence(licence, licence_authority_slug, snac_code)

    authority_required = snac_code.present? || licence_authority_slug.present?
    raise RecordNotFound if authority_required && ! licence_attributes[:authority]

    if licence_attributes[:authority]
      licence_attributes[:action] = interaction
      available_actions = licence_attributes[:authority]['actions'].keys + ["apply","renew","change"]

      raise RecordNotFound unless appropriate_action_available?(licence_attributes[:action], available_actions)
    end

    return licence_attributes
  end

  protected
    def appropriate_action_available?(action, available_actions)
      action.blank? || available_actions.include?(action)
    end

    def missing_or_invalid_licence?(licence)
      licence.blank? || licence['error'].present?
    end

    def authority_for_licence(licence, licence_authority_slug, snac_code)
      if licence["location_specific"]
        if snac_code
          licence['authorities'].first
        end
      else
        if licence['authorities'].size == 1
          licence['authorities'].first
        elsif licence_authority_slug
          licence['authorities'].select {|authority| authority['slug'] == licence_authority_slug }.first
        end
      end
    end
end