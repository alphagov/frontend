module WorldwideOrganisations
  extend ActiveSupport::Concern

  included do
    def worldwide_organisations
      linked("worldwide_organisations")
    end
  end
end
