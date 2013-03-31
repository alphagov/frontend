class LicenceDetailsFromArtefact
  attr_accessor :licence, :snac_code, :licence_authority_slug, :interaction

  def initialize(artefact, licence_authority_slug, snac_code, interaction = nil)
    self.licence = artefact['details']['licence']
    self.snac_code = snac_code
    self.licence_authority_slug = licence_authority_slug
    self.interaction = interaction
  end

  def build_attributes
    return false if missing_or_invalid_licence?(licence)

    licence_attributes = { 
      licence: licence,
      authority: authority_for_licence
    }

    if licence_attributes[:authority]
      licence_attributes[:action] = licence_action(interaction, licence_attributes[:authority]['actions'].keys)
    elsif authority_required?
      raise RecordNotFound
    end

    licence_attributes
  end

  protected

    def location_specific?
      licence["location_specific"]
    end

    def authority_required?
      snac_code.present? || licence_authority_slug.present?
    end

    def licence_action(interaction, authority_actions)
      available_actions = authority_actions + ["apply", "renew", "change"]
      raise RecordNotFound unless appropriate_action_available?(interaction, available_actions)
      interaction
    end

    def appropriate_action_available?(action, available_actions)
      action.blank? || available_actions.include?(action)
    end

    def missing_or_invalid_licence?(licence)
      licence.blank? || licence['error'].present?
    end

    def authority_for_licence
      if location_specific?
        if snac_code
          licence['authorities'].first
        end
      else
        if licence['authorities'].size == 1
          licence['authorities'].first
        elsif licence_authority_slug
          licence['authorities'].select { |authority| authority['slug'] == licence_authority_slug }.first
        end
      end
    end
end