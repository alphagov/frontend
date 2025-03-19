require "postcode_sanitizer"

class FindLocalCouncilController < ContentItemsController
  include Cacheable

  skip_before_action :set_locale
  skip_before_action :verify_authenticity_token, only: [:find]

  BASE_PATH = "/find-local-council".freeze

  def index; end

  def find
    # get location info, raising a LocationError if there's a problem
    postcode_lookup = PostcodeLookup.new(postcode)

    if postcode_lookup.local_custodian_codes.count == 1
      # if location simple, look up authority details and redirect there.
      local_authority = LocalAuthority.from_local_custodian_code(postcode_lookup.local_custodian_codes.first)
      respond_to do |format|
        format.html { redirect_to "#{BASE_PATH}/#{local_authority.slug}" }
        format.json { redirect_to "#{BASE_PATH}/#{local_authority.slug}.json" }
      end
    else
      # if location ambiguous, point to multiple authorities
      @address_list_presenter = AddressListPresenter.new(postcode_lookup.addresses)
      respond_to do |format|
        format.json { render json: @address_list_presenter.addresses_with_authority_data }
        format.html { render :multiple_authorities }
      end
    end
  rescue LocationError => e
    @location_error = e
    render :index
  end

  def multiple_authorities
    redirect_to "#{BASE_PATH}/#{params[:authority_slug]}"
  end

  def result
    @local_authority = LocalAuthority.from_slug(params[:authority_slug])

    respond_to do |format|
      format.json { render json: { local_authority: @local_authority.to_h } }
      format.html do
        if @local_authority.parent.blank?
          render :one_council
        else
          @county = @local_authority.parent
          @district = @local_authority

          render :district_and_county_council
        end
      end
    end
  end

private

  def content_item_path
    BASE_PATH
  end

  def postcode
    @postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
  end
end
