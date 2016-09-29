require 'test_helper'

module SimpleSmartAnswers
  class FlowTest < ActiveSupport::TestCase
    context "finding nodes" do
      setup do
        @nodes = [
          {
            "kind" => "question",
            "slug" => "question-1",
            "title" => "Question 1",
            "body" => "<p>This is question 1</p>",
            "options" => [],
          },
          {
            "kind" => "question",
            "slug" => "question-2",
            "title" => "Question 2",
            "body" => "<p>This is question 2</p>",
            "options" => [],
          },
          {
            "kind" => "outcome",
            "slug" => "outcome-1",
            "title" => "Outcome 1",
            "body" => "<p>This is outcome 1</p>",
          },
          {
            "kind" => "outcome",
            "slug" => "outcome-1",
            "title" => "Outcome 1",
            "body" => "<p>This is outcome 1</p>",
          },
        ]
        @flow = Flow.new(@nodes)
      end

      should "return the node matching the slug" do
        node = @flow.node_for_slug('question-2')
        assert node.is_a?(Node)
        assert_equal "Question 2", node.title
      end

      should "return nil if none match" do
        assert_nil @flow.node_for_slug('question-3')
      end

      should "return the first node as the start_node" do
        node = @flow.start_node
        assert node.is_a?(Node)
        assert_equal "Question 1", node.title
      end
    end

    context "state_for_responses" do
      setup do
        @flow = Flow.new([
          {
            "kind" => "question",
            "slug" => "question-1",
            "title" => "Question 1",
            "body" => "<p>This is question 1</p>",
            "options" => [
              {
                "label" => "Option 1",
                "slug" => "option-1",
                "next_node" => "question-2",
              },
              {
                "label" => "Option 2",
                "slug" => "option-2",
                "next_node" => "outcome-1",
              },
              {
                "label" => "Option 3",
                "slug" => "option-3",
                "next_node" => "outcome-2",
              },
            ],
          },
          {
            "kind" => "question",
            "slug" => "question-2",
            "title" => "Question 2",
            "body" => "<p>This is question 2</p>",
            "options" => [
              {
                "label" => "Option 1",
                "slug" => "option-1",
                "next_node" => "outcome-1",
              },
              {
                "label" => "Option 2",
                "slug" => "option-2",
                "next_node" => "outcome-2",
              },
            ],
          },
          {
            "kind" => "outcome",
            "slug" => "outcome-1",
            "title" => "Outcome 1",
            "body" => "<p>This is outcome 1</p>",
          },
          {
            "kind" => "outcome",
            "slug" => "outcome-2",
            "title" => "Outcome 2",
            "body" => "<p>This is outcome 2</p>",
          },
        ])
      end

      should "return a state for the given responses" do
        state = @flow.state_for_responses(["option-1"])

        assert_equal "question-2", state.current_node.slug
        assert_equal 2, state.current_question_number

        assert_equal 1, state.completed_questions.size
        answer1 = state.completed_questions.first
        assert_equal "Option 1", answer1.label
        assert_equal "option-1", answer1.slug
        assert_equal "Question 1", answer1.question.title
      end

      should "stop processing and set error flag on invalid response" do
        state = @flow.state_for_responses(["option-1", "fooey", "option-2"])

        assert state.error?
        assert_equal "question-2", state.current_node.slug
        assert_equal 2, state.current_question_number

        assert_equal 1, state.completed_questions.size
        assert_equal "option-1", state.completed_questions.first.slug
      end
    end
  end
end
