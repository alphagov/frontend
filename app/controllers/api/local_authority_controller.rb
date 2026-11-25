# rubocop:disable Rails/ApplicationController
module Api
  class LocalAuthorityController < ActionController::Base
    def index
      postcode_lookup = PostcodeLookup.new(postcode)

      if postcode_lookup.local_custodian_codes.count == 1
        local_authority = LocalAuthority.from_local_custodian_code(postcode_lookup.local_custodian_codes.first)
        redirect_to "/api/local-authority/#{local_authority.slug}"
      else
        @address_list_presenter = AddressListPresenter.new(postcode_lookup.addresses)
        render json: { addresses: @address_list_presenter.addresses_with_authority_data }
      end
    rescue PostcodeLookup::PostcodeInvalid
      render json: { errors: { postcode: ["Enter a valid postcode."] } }, status: :bad_request
    rescue PostcodeLookup::PostcodeError
      render json: { errors: { postcode: ["We couldn't find a council for this postcode."] } }, status: :not_found
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
# rubocop:enable Rails/ApplicationController
