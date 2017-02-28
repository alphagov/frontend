class LicenceDetailsFromLicensify
  attr_accessor :licence, :snac_code, :licence_authority_slug, :interaction

  def initialize(artefact, licence_authority_slug, snac_code, interaction = nil)
    @artefact = artefact
    @licence_authority_slug = licence_authority_slug
    @snac_code = snac_code
    @interaction = interaction
  end

  def build_attributes
    return false if missing_or_invalid_licence?

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

  def licence_action(interaction, authority_actions)
    available_actions = authority_actions
    raise RecordNotFound unless appropriate_action_available?(interaction, available_actions)
    interaction
  end

  def appropriate_action_available?(action, available_actions)
    action.blank? || available_actions.include?(action)
  end


  def missing_or_invalid_licence?
    licence.blank? || licence['error'].present?
  end

  def licence
    LicenceDetailsPresenter.new(licence_api_response).present
  end

  def licence_api_response
    @_response ||= Services.licensify.details_for_licence(@artefact["details"]["licence_identifier"], snac_code)
  rescue GdsApi::HTTPErrorResponse, GdsApi::TimedOutException
    nil
  end

  def authority_for_licence
    if location_specific?
      licence['authorities'].first if snac_code
    elsif licence['authorities'].size == 1
      licence['authorities'].first
    elsif licence_authority_slug
      licence['authorities'].detect { |authority| authority['slug'] == licence_authority_slug }
    end
  end

  def location_specific?
    licence["location_specific"].present?
  end

  def authority_required?
    snac_code.present? || licence_authority_slug.present?
  end
end
