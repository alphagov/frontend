require 'test_helper'
require 'gds_api/test_helpers/content_api'

class SimpleSmartAnswersControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentApi

  context "GET 'flow'" do
    context "for a simple_smart_answer slug" do
      setup do
        @artefact = artefact_for_slug('the-bridge-of-death')
        @artefact["format"] = "simple_smart_answer"
        @node_details = [
          {
            "kind" => "question",
            "slug" => "question-1",
            "title" => "Question 1",
            "body" => "<p>This is question 1</p>",
            "options" => [
              {"label" => "Option 1", "slug" => "option-1", "next_node" => "question-2"},
              {"label" => "Option 2", "slug" => "option-2", "next_node" => "outcome-1"},
              {"label" => "Option 3", "slug" => "option-3", "next_node" => "outcome-2"},
            ],
          },
          {
            "kind" => "question",
            "slug" => "question-2",
            "title" => "Question 2",
            "body" => "<p>This is question 2</p>",
            "options" => [
              {"label" => "Option 1", "slug" => "option-1", "next_node" => "outcome-1"},
              {"label" => "Option 2", "slug" => "option-2", "next_node" => "outcome-2"},
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
        @artefact["details"]["nodes"] = @node_details
        content_api_has_an_artefact('the-bridge-of-death', @artefact)
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

      should "not set cache control headers when previewing" do
        get :flow, slug: "the-bridge-of-death", responses: "option-1/option-2", edition: 2

        assert_equal "no-cache", response.headers["Cache-Control"]
      end

      should "send the artefact to Slimmer" do
        get :flow, slug: "the-bridge-of-death", responses: "option-1/option-2"

        assert_equal @artefact.to_json, response.headers["X-Slimmer-Artefact"]
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
      end
    end

    should "return a cacheable 404 if the slug doesn't exist" do
      content_api_does_not_have_an_artefact('fooey')

      get :flow, slug: 'fooey'
      assert_equal 404, response.status
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
    end

    should "return a cacheable 404 if the slug isn't a simple_smart_answer" do
      content_api_has_an_artefact('vat')

      get :flow, slug: 'vat'
      assert_equal 404, response.status
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
    end

    should "503 if content_api times out" do
      stub_request(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}}).to_timeout

      get :flow, slug: 'fooey'
      assert_equal 503, response.status
    end
  end
end
