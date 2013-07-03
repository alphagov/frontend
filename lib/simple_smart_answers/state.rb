module SimpleSmartAnswers
  class State
    def initialize(flow, initial_node)
      @flow = flow
      @current_node = initial_node
      @completed_questions = []
      @error = false
    end

    attr_reader :current_node, :completed_questions

    def error?
      @error
    end

    def process_responses(responses)
      responses.each do |response|
        add_response(response)
        break if self.error?
      end
      self
    end

    def add_response(response_slug)
      response = @current_node.process_response(response_slug)
      @current_node = response.next_node
      @completed_questions << response
    rescue InvalidResponse
      @error = true
    end

    def current_question_number
      @completed_questions.size + 1
    end
  end
end
