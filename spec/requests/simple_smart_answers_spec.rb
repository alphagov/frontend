RSpec.describe "Simple Smart Answers" do
  def simple_smart_answer_content_item
    {
      base_path: "/the-bridge-of-death",
      document_type: "simple_smart_answer",
      schema_name: "simple_smart_answer",
      title: "The bridge of death",
      description: "Cheery description about bridge of death",
      external_related_links: [],
    }
  end

  def simple_smart_answer_content_item_with_start_button_text
    {
      base_path: "/the-squirrel-of-doom",
      document_type: "simple_smart_answer",
      schema_name: "simple_smart_answer",
      title: "The squirrel of doom",
      description: "Noooo, not the squirrel of doom!",
      details: {
        start_button_text: "Start now",
      },
      external_related_links: [],
    }
  end

  context "GET 'start page'" do
    it_behaves_like "it can render the govuk_chat promo banner", "/the-bridge-of-death"

    before do
      content_store_has_random_item(base_path: "/the-bridge-of-death", schema: "simple_smart_answer")
    end

    it "sets the cache expiry headers" do
      get "/the-bridge-of-death"
      honours_content_store_ttl
    end
  end

  context "GET 'question flow'" do
    context "for a simple_smart_answer slug" do
      before do
        @node_details = [
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
        ]
        payload =
          simple_smart_answer_content_item.merge(
            details: {
              start_button_text: "Start here",
              body: "Hello",
              nodes: @node_details,
            },
          )
        stub_content_store_has_item("/the-bridge-of-death", payload)
      end

      it "calculates the flow state with no responses" do
        flow = SimpleSmartAnswers::Flow.new(@node_details)
        state = flow.state_for_responses([])
        allow(SimpleSmartAnswers::Flow).to receive(:new).with(
          @node_details,
        ).and_return(flow)
        allow(flow).to receive(:state_for_responses).with([]).and_return(state)
        get "/the-bridge-of-death/y"

        expect(assigns[:flow_state]).to eq(state)
      end

      it "calculates the flow state for the given responses" do
        flow = SimpleSmartAnswers::Flow.new(@node_details)
        state = flow.state_for_responses(%w[option-1 option-2])
        allow(SimpleSmartAnswers::Flow).to receive(:new).with(
          @node_details,
        ).and_return(flow)
        allow(flow).to receive(:state_for_responses).with(
          %w[option-1 option-2],
        ).and_return(state)
        get "/the-bridge-of-death/y/option-1/option-2"

        expect(assigns[:flow_state]).to eq(state)
      end

      it "renders the flow template" do
        get "/the-bridge-of-death/y/option-1/option-2"

        expect(response).to render_template(:flow)
      end

      it "sets cache control headers" do
        get "/the-bridge-of-death/y/option-1/option-2"

        honours_content_store_ttl
      end

      context "with form submission params" do
        it "adds the given response to the state" do
          get "/the-bridge-of-death/y/option-1", params: { response: "option-1" }
          state = assigns[:flow_state]

          expect(state.completed_questions.map(&:slug)).to eq(%w[option-1 option-1])
        end

        it "redirects to the canonical path for the resulting state" do
          get "/the-bridge-of-death/y/option-1", params: { response: "option-2" }

          expect(response).to redirect_to("/the-bridge-of-death/y/option-1/option-2")
        end

        it "sets cache control headers when redirecting" do
          get "/the-bridge-of-death/y/option-1", params: { response: "option-2" }

          honours_content_store_ttl
        end

        it "does not redirect if the form submission results in an error" do
          get "/the-bridge-of-death/y/option-1", params: { response: "fooey" }

          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:flow)
          expect(assigns[:flow_state].current_node.slug).to eq("question-2")
        end

        it "does not process form param with invalid url params" do
          get "/the-bridge-of-death/y/fooey", params: { response: "option-1" }

          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:flow)
          expect(assigns[:flow_state].current_node.slug).to eq("question-1")
        end

        it "passes on the 'token' param when in fact check" do
          get "/the-bridge-of-death/y/option-1", params: { response: "option-2", token: "123" }

          expect(response).to redirect_to("/the-bridge-of-death/y/option-1/option-2?token=123")
        end
      end
    end
  end
end
