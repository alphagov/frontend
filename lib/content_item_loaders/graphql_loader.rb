require "govuk_content_item_loader/govuk_conditional_content_item_loader"

module ContentItemLoaders
  class GraphqlLoader
    attr_reader :conditional_graphql_loader

    def initialize(request:)
      @conditional_graphql_loader = GovukConditionalContentItemLoader.new(request:)
    end

    def can_load?(*)
      conditional_graphql_loader.can_load_from_graphql?
    end

    def load(*)
      conditional_graphql_loader.load
    end
  end
end
