module EmphasisedOrganisations
  extend ActiveSupport::Concern

  included do
    def organisations_ordered_by_emphasis
      orgs_in_order = []

      emphasised_organisations.each do |emphasised_id|
        organisation = organisations.find { it.content_id == emphasised_id }
        orgs_in_order << organisation if organisation
      end

      orgs_in_order + organisations.reject { emphasised?(it) }.sort_by(&:title)
    end
  end

private

  def emphasised?(organisation)
    organisation.content_id.in?(emphasised_organisations)
  end

  def emphasised_organisations
    content_store_response.dig("details", "emphasised_organisations") || []
  end
end
