require 'simple_smart_answers/node'
require 'simple_smart_answers/state'

module SimpleSmartAnswers
  class Flow
    def initialize(node_details)
      @nodes = {}
      node_details.each_with_index do |n, i|
        node = Node.new(self, n)
        @nodes[node.slug] = node
        @start_node = node if i == 0
      end
    end

    attr_reader :start_node

    def node_for_slug(slug)
      @nodes[slug]
    end

    def state_for_responses(responses)
      state = State.new(self, start_node)
      state.process_responses(responses)
    end
  end
end
