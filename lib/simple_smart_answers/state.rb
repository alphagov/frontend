module SimpleSmartAnswers
  class State
    def initialize(flow, initial_node)
      @flow = flow
      @current_node = initial_node
      @responses = []
    end

    attr_reader :current_node

    def process_responses(responses)
      responses.each do |response|
        add_response(response)
      end
      self
    end

    def add_response(response_slug)
      next_node = @current_node.next_node_for_response(response_slug)
      @responses << response_slug
      @current_node = next_node
      self
    end

    def current_question_number
      @responses.size + 1
    end
  end
end
