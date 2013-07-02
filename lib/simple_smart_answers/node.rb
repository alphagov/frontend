require_relative 'errors'
require 'ostruct'

module SimpleSmartAnswers
  class Node
    def initialize(flow, details)
      @flow = flow
      @kind = details["kind"]
      @slug = details["slug"]
      @title = details["title"]
      @body = details["body"]
      @options = details["options"].map {|o| build_option(o) } if details["options"]
    end

    attr_reader :kind, :slug, :title, :body, :options

    def outcome?
      @kind == "outcome"
    end

    def next_node_for_response(response_slug)
      option = @options.find { |o| o.slug == response_slug }
      raise InvalidResponse if option.nil?
      node = @flow.node_for_slug(option.next)
      raise InvalidResponse if node.nil?
      node
    end

    def process_response(response_slug)
      option = @options.find { |o| o.slug == response_slug }
      raise InvalidResponse if option.nil?
      option.next_node ||= @flow.node_for_slug(option.next_node_slug)
      raise InvalidResponse if option.next_node.nil? # TODO: should this be a different exception?
      option
    end

    private

    def build_option(details)
      OpenStruct.new({
        :question => self,
        :label => details["label"],
        :slug => details["slug"],
        :next_node_slug => details["next"],
      })
    end
  end
end
