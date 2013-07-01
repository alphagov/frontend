require_relative 'errors'

module SimpleSmartAnswers
  class Node
    def initialize(flow, details)
      @flow = flow
      @kind = details["kind"]
      @slug = details["slug"]
      @title = details["title"]
      @body = details["body"]
      @options = details["options"].map {|o| OpenStruct.new(o) } if details["options"]
    end

    attr_reader :kind, :slug, :title, :body, :options

    def next_node_for_response(response_slug)
      option = @options.find { |o| o.slug == response_slug }
      raise InvalidResponse if option.nil?
      node = @flow.node_for_slug(option.next)
      raise InvalidResponse if node.nil?
      node
    end
  end
end
