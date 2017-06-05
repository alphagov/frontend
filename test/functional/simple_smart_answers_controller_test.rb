require 'test_helper'

class SimpleSmartAnswersControllerTest < ActionController::TestCase
  include EducationNavigationAbTestHelper

  def simple_smart_answer_content_item
    {
      base_path: "/the-bridge-of-death",
      document_type: "simple_smart_answer",
      schema_name: "simple_smart_answer",
      title: "The bridge of death",
      description: "Cheery description about bridge of death",
      external_related_links: []
    }
  end

  context "GET show" do
    setup do
      content_store_has_random_item(base_path: "/the-bridge-of-death", schema: 'simple_smart_answer')
    end

    context "for live content" do
      should "set the cache expiry headers" do
        get :show, slug: "the-bridge-of-death"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    context "A/B testing" do
      setup do
        setup_education_navigation_ab_test
        content_store_has_item_tagged_to_taxon(
          base_path: '/the-bridge-of-death',
          payload: simple_smart_answer_content_item
        )
      end

      %w[A B].each do |variant|
        should "not affect non-education pages with the #{variant} variant" do
          content_store_has_random_item(base_path: "/the-bridge-of-death", schema: 'simple_smart_answer')
          setup_ab_variant('EducationNavigation', variant)
          expect_normal_navigation
          get :show, slug: "the-bridge-of-death"
          assert_response_not_modified_for_ab_test('EducationNavigation')
        end
      end

      should "show normal navigation by default" do
        expect_normal_navigation
        get :show, slug: "the-bridge-of-death"
      end

      should "show normal navigation for the 'A' version" do
        expect_normal_navigation
        with_variant EducationNavigation: "A" do
          get :show, slug: "the-bridge-of-death"
        end
      end

      should "show taxon navigation for the 'B' version" do
        expect_new_navigation
        with_variant EducationNavigation: "B" do
          get :show, slug: "the-bridge-of-death"
        end
      end
    end
  end

  context "GET 'flow'" do
    context "for a simple_smart_answer slug" do
      setup do
        @node_details = [
          {
            "kind" => "question",
            "slug" => "question-1",
            "title" => "Question 1",
            "body" => "<p>This is question 1</p>",
            "options" => [
              { "label" => "Option 1", "slug" => "option-1", "next_node" => "question-2" },
              { "label" => "Option 2", "slug" => "option-2", "next_node" => "outcome-1" },
              { "label" => "Option 3", "slug" => "option-3", "next_node" => "outcome-2" },
            ],
          },
          {
            "kind" => "question",
            "slug" => "question-2",
            "title" => "Question 2",
            "body" => "<p>This is question 2</p>",
            "options" => [
              { "label" => "Option 1", "slug" => "option-1", "next_node" => "outcome-1" },
              { "label" => "Option 2", "slug" => "option-2", "next_node" => "outcome-2" },
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
        ]

        payload = simple_smart_answer_content_item.merge(
          details: {
            start_button_text: "Start here",
            body: "Hello",
            nodes: @node_details,
          }
        )

        content_store_has_item('/the-bridge-of-death', payload)
      end

      should "calculate the flow state with no responses" do
        flow = SimpleSmartAnswers::Flow.new(@node_details)
        state = flow.state_for_responses([])
        SimpleSmartAnswers::Flow.expects(:new).with(@node_details).returns(flow)
        flow.expects(:state_for_responses).with([]).returns(state)

        get :flow, slug: "the-bridge-of-death"

        assert_equal state, assigns[:flow_state]
      end

      should "calculate the flow state for the given responses" do
        flow = SimpleSmartAnswers::Flow.new(@node_details)
        state = flow.state_for_responses(["option-1", "option-2"])
        SimpleSmartAnswers::Flow.expects(:new).with(@node_details).returns(flow)
        flow.expects(:state_for_responses).with(["option-1", "option-2"]).returns(state)

        get :flow, slug: "the-bridge-of-death", responses: "option-1/option-2"

        assert_equal state, assigns[:flow_state]
      end

      should "render the flow template" do
        get :flow, slug: "the-bridge-of-death", responses: "option-1/option-2"

        assert_template "flow"
      end

      should "set cache control headers" do
        get :flow, slug: "the-bridge-of-death", responses: "option-1/option-2"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      context "with form submission params" do
        should "add the given response to the state" do
          get :flow, slug: "the-bridge-of-death", responses: "option-1", response: "option-1"

          state = assigns[:flow_state]
          assert_equal ['option-1', 'option-1'], state.completed_questions.map(&:slug)
        end

        should "redirect to the canonical path for the resulting state" do
          get :flow, slug: "the-bridge-of-death", responses: "option-1", response: "option-2"

          assert_redirected_to action: :flow, slug: "the-bridge-of-death", responses: "option-1/option-2"
        end

        should "set cache control headers when redirecting" do
          get :flow, slug: "the-bridge-of-death", responses: "option-1", response: "option-2"

          assert_equal "max-age=1800, public", response.headers["Cache-Control"]
        end

        should "not redirect if the form submission results in an error" do
          get :flow, slug: "the-bridge-of-death", responses: "option-1", response: "fooey"

          assert_equal 200, response.status
          assert_template "flow"
          assert_equal 'question-2', assigns[:flow_state].current_node.slug
        end

        should "not process form param with invalid url params" do
          get :flow, slug: "the-bridge-of-death", responses: "fooey", response: "option-1"

          assert_equal 200, response.status
          assert_template "flow"
          assert_equal 'question-1', assigns[:flow_state].current_node.slug
        end

        should "pass on the 'token' param when in fact check" do
          get :flow, slug: "the-bridge-of-death", responses: "option-1", response: "option-2", token: "123"

          assert_redirected_to action: :flow, slug: "the-bridge-of-death", responses: "option-1/option-2", token: "123"
        end
      end
    end
  end
end
