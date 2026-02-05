require "govuk_app_config/govuk_graphql"

module ContentItemLoaders
  class GraphqlLoader
    attr_reader :conditional_graphql_loader

    def initialize(request:)
      @conditional_graphql_loader = GovukGraphQL::ConditionalContentItemLoader.new(request:)
    end

    def can_load?(*)
      conditional_graphql_loader.can_load_from_graphql?
    end

    def load(*)
      conditional_graphql_loader.load
    end
  end
end
