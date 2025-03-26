module Api
  class LocalAuthorityController < Api::BaseController
    def index
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
      @local_authority = LocalAuthority.from_slug(params[:authority_slug])

      render json: { local_authority: @local_authority.to_h }
    rescue GdsApi::HTTPNotFound
      render json: { errors: { local_authority_slug: ["Not found"] } }, status: :not_found
    end

  private

    def postcode
      @postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
    end
  end
end
