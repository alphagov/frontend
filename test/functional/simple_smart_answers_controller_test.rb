require_relative '../test_helper'
require 'gds_api/test_helpers/content_api'

class SimpleSmartAnswersControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentApi

  context "GET 'flow'" do
    context "for a simple_smart_answer slug" do
      setup do
        artefact = artefact_for_slug('the-bridge-of-death')
        artefact["format"] = "simple_smart_answer"
        artefact["details"]["nodes"] = ["some nodes"]
        content_api_has_an_artefact('the-bridge-of-death', artefact)
      end

      context "without any form submission params" do
        setup do
          @stub_flow_state = OpenStruct.new(
            :completed_questions => [],
            :current_node => OpenStruct.new(:kind => "question", :options => [])
          )
          SimpleSmartAnswers::Flow.any_instance.stubs(:state_for_responses).returns(@stub_flow_state)
        end

        should "calculate the flow state with no responses" do
          flow = mock("SimpleSmartAnswers::Flow")
          SimpleSmartAnswers::Flow.expects(:new).with(["some nodes"]).returns(flow)
          flow.expects(:state_for_responses).with([]).returns(@stub_flow_state)

          get :flow, :slug => "the-bridge-of-death"

          assert_equal @stub_flow_state, assigns[:flow_state]
        end

        should "calculate the flow state for the given responses" do
          flow = stub("SimpleSmartAnswers::Flow")
          SimpleSmartAnswers::Flow.expects(:new).with(["some nodes"]).returns(flow)
          flow.expects(:state_for_responses).with(["foo", "bar"]).returns(@stub_flow_state)

          get :flow, :slug => "the-bridge-of-death", :responses => "foo/bar"

          assert_equal @stub_flow_state, assigns[:flow_state]
        end

        should "render the flow template" do
          get :flow, :slug => "the-bridge-of-death", :responses => "foo/bar"

          assert_template "flow"
        end
      end

      context "with form submission params" do
        setup do
          @stub_flow_state = OpenStruct.new(
            :completed_questions => [],
            :current_node => OpenStruct.new(:kind => "question", :options => [])
          )
          @stub_flow_state.stubs(:add_response)
          SimpleSmartAnswers::Flow.any_instance.stubs(:state_for_responses).returns(@stub_flow_state)
        end

        should "add the given response to the state" do
          @stub_flow_state.expects(:add_response).with('baz')
          get :flow, :slug => "the-bridge-of-death", :responses => "foo/bar", :response => "baz"
        end

        should "redirect to the canonical path for the resulting state" do
          # We've stubbed the flow, so it will ignore the actual request params.
          @stub_flow_state.completed_questions << stub("Response", :slug => "foo")
          @stub_flow_state.completed_questions << stub("Response", :slug => "bar")
          @stub_flow_state.completed_questions << stub("Response", :slug => "baz")

          get :flow, :slug => "the-bridge-of-death", :responses => "foo/bar", :response => "baz"

          assert_redirected_to :action => :flow, :slug => "the-bridge-of-death", :responses => "foo/bar/baz"
        end
      end
    end

    should "return a cacheable 404 if the slug doesn't exist" do
      content_api_does_not_have_an_artefact('fooey')

      get :flow, :slug => 'fooey'
      assert_equal 404, response.status
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
    end

    should "return a cacheable 404 if the slug isn't a simple_smart_answer" do
      content_api_has_an_artefact('vat')

      get :flow, :slug => 'vat'
      assert_equal 404, response.status
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
    end

    should "503 if content_api times out" do
      stub_request(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}}).to_timeout

      get :flow, :slug => 'fooey'
      assert_equal 503, response.status
    end
  end
end
