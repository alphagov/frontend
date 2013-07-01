require_relative '../../test_helper'

module SimpleSmartAnswers
  class NodeTest < ActiveSupport::TestCase

    should "have attribute accessors for basic fields" do
      node = Node.new(:a_flow, "kind" => "question", "slug" => "question-1",
            "title" => "Question 1", "body" => "<p>This is question 1</p>", "options" => [])

      assert_equal "question", node.kind
      assert_equal "Question 1", node.title
      assert_equal "question-1", node.slug
      assert_equal "<p>This is question 1</p>", node.body
    end

    context "options" do
      setup do
        @flow = stub("Flow", :node_for_slug => nil)
        @node = Node.new(@flow, "kind" => "question", "slug" => "question-1", "options" => [
          {
            "label" => "Option 1",
            "slug" => "option-1",
            "next" => "question-2",
          },
          {
            "label" => "Option 3",
            "slug" => "option-3",
            "next" => "question-3",
          },
          {
            "label" => "Option 2",
            "slug" => "option-2",
            "next" => "question-2",
          },
        ])
      end

      should "construct options" do
        assert_equal 3, @node.options.size
        assert_equal ["Option 1", "Option 3", "Option 2"], @node.options.map(&:label)
        assert_equal %w(option-1 option-3 option-2), @node.options.map(&:slug)
        assert_equal %w(question-2 question-3 question-2), @node.options.map(&:next)
      end

      context "next_node_for_response" do
        should "return the next node slug for the given response" do
          @flow.expects(:node_for_slug).with("question-2").returns(:question_2_node)
          assert_equal :question_2_node, @node.next_node_for_response("option-2")
        end

        should "raise InvalidResponse if the next points to a non-existent node" do
          @flow.expects(:node_for_slug).with("question-2").returns(nil)
          assert_raise InvalidResponse do
            @node.next_node_for_response("option-2")
          end
        end

        should "raise InvalidResponse if given an invalid response" do
          assert_raise InvalidResponse do
            @node.next_node_for_response("option-4")
          end
        end
      end
    end
  end
end
