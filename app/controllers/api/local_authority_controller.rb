# rubocop:disable Rails/ApplicationController
module Api
  class LocalAuthorityController < ActionController::Base
    def show
      @local_authority = LocalAuthority.from_slug(params[:authority_slug])

      render json: { local_authority: @local_authority.to_h }
    rescue GdsApi::HTTPNotFound
      render json: { errors: { local_authority_slug: ["Not found"] } }, status: :not_found
    end
  end
end
# rubocop:enable Rails/ApplicationController
