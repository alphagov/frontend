require 'test_helper'

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

    context "outcome?" do
      should "be true for an outcome node" do
        assert Node.new(:a_flow, "kind" => "outcome").outcome?
      end

      should "be false for a question node" do
        refute Node.new(:a_flow, "kind" => "question").outcome?
      end
    end

    context "options" do
      setup do
        @flow = stub("Flow", node_for_slug: :a_node)
        @node = Node.new(@flow, "kind" => "question", "slug" => "question-1", "options" => [
          {
            "label" => "Option 1",
            "slug" => "option-1",
            "next_node" => "question-2",
          },
          {
            "label" => "Option 3",
            "slug" => "option-3",
            "next_node" => "question-3",
          },
          {
            "label" => "Option 2",
            "slug" => "option-2",
            "next_node" => "question-2",
          },
        ])
      end

      should "construct options" do
        assert_equal ["Option 1", "Option 3", "Option 2"], @node.options.map(&:label)
        assert_equal %w(option-1 option-3 option-2), @node.options.map(&:slug)
        assert_equal %w(question-2 question-3 question-2), @node.options.map(&:next_node_slug)
        assert_equal @node, @node.options.first.question
      end

      context "process_response" do
        should "return the matching option instance" do
          assert_equal "Option 2", @node.process_response('option-2').label
        end

        should "populate the next_node on the returned option" do
          @flow.stubs(:node_for_slug).with('question-2').returns(:question_2_node)
          assert_equal :question_2_node, @node.process_response('option-2').next_node
        end

        should "raise InvalidResponse if no option matches" do
          assert_raise InvalidResponse do
            @node.process_response('option-4')
          end
        end

        should "raise InvalidResponse if option points to a non-existent node" do
          @flow.stubs(:node_for_slug).with('question-2').returns(nil)
          assert_raise InvalidResponse do
            @node.process_response('option-2')
          end
        end
      end
    end
  end
end
