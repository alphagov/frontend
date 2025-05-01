module Api
  class LocalAuthorityController < Api::BaseController
    def index
      return fake_index_query if Rails.env.production?

      postcode_lookup = PostcodeLookup.new(postcode)

      if postcode_lookup.local_custodian_codes.count == 1
        local_authority = LocalAuthority.from_local_custodian_code(postcode_lookup.local_custodian_codes.first)
        redirect_to "/api/local-authority/#{local_authority.slug}"
      else
        @address_list_presenter = AddressListPresenter.new(postcode_lookup.addresses)
        render json: { addresses: @address_list_presenter.addresses_with_authority_data }
      end
    rescue LocationError => e
      status = e.postcode_error == "invalidPostcodeFormat" ? :bad_request : :not_found
      render json: { errors: { postcode: [I18n.t(e.message)] } }, status:
    end

    def show
      @local_authority = Rails.env.production? ? fake_local_authority : LocalAuthority.from_slug(params[:authority_slug])

      render json: { local_authority: @local_authority.to_h }
    rescue GdsApi::HTTPNotFound
      render json: { errors: { local_authority_slug: ["Not found"] } }, status: :not_found
    end

  private

    FAKE_ADDRESS_LIST = [
      { address: "PEARDOWN HOUSE, FENAPPLE CLOSE, BREAM ROAD, WEST THYME, APPLETON, SW1A 2BB", slug: "dorset", name: "Dorset Council" },
      { address: "STRAWBERRY COTTAGE, FENAPPLE CLOSE, BREAM ROAD, WEST THYME, APPLETON, SW1A 2BB", slug: "westminster", name: "City of Westminster" },
    ].freeze

    def fake_index_query
      raise LocationError, "invalidPostcodeFormat" if postcode.blank?

      case postcode
      when "BAD"
        raise LocationError, "invalidPostcodeFormat"
      when "SW1A 2AA"
        redirect_to "/api/local-authority/westminster"
      when "SW1A 2BB"
        render json: { addresses: FAKE_ADDRESS_LIST }
      else
        raise LocationError, "noLaMatch"
      end
    end

    def fake_local_authority
      case params[:authority_slug]
      when "missing"
        raise GdsApi::HTTPNotFound, 404
      when "derbyshire-dales"
        parent = LocalAuthority.new({ "slug" => "derbyshire", "name" => "Derbyshire County Council", "tier" => "county", "homepage_url" => "https://www.gov.uk" })
        LocalAuthority.new({ "slug" => "derbyshire-dales", "name" => "Derbyshire Dales District Council", "tier" => "district", "homepage_url" => "https://www.gov.uk" }, parent:)
      else
        LocalAuthority.new({ "slug" => params[:authority_slug], "name" => params[:authority_slug].gsub("-", " ").titleize, "tier" => "unitary", "homepage_url" => "https://www.gov.uk" })
      end
    end

    def postcode
      @postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
    end
  end
end
