module Organisations
  extend ActiveSupport::Concern
  include Links

  included do
    has_links :emphasised_organisations
    has_links :organisations

    def organisations_ordered_by_emphasis
      organisations.sort_by { |organisation| emphasised?(organisation) ? -1 : 1 }
    end
  end

private

  def emphasised?(organisation)
    organisation["content_id"].in?(emphasised_organisations)
  end
end
