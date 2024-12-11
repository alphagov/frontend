module SimpleSmartAnswers
  RSpec.describe Flow do
    context "finding nodes" do
      before do
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
        @flow = described_class.new(@nodes)
      end

      it "returns the node matching the slug" do
        node = @flow.node_for_slug("question-2")

        expect(node).to be_a(Node)
        expect(node.title).to eq("Question 2")
      end

      it "returns nil if none match" do
        expect(@flow.node_for_slug("question-3")).to be_nil
      end

      it "returns the first node as the start_node" do
        node = @flow.start_node

        expect(node).to be_a(Node)
        expect(node.title).to eq("Question 1")
      end
    end

    describe "#state_for_responses" do
      before do
        @flow =
          described_class.new(
            [
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
            ],
          )
      end

      it "returns a state for the given responses" do
        state = @flow.state_for_responses(%w[option-1])

        expect(state.current_node.slug).to eq("question-2")
        expect(state.current_question_number).to eq(2)
        expect(state.completed_questions.size).to eq(1)

        answer1 = state.completed_questions.first
        expect(answer1.label).to eq("Option 1")
        expect(answer1.slug).to eq("option-1")
        expect(answer1.question.title).to eq("Question 1")
      end

      it "stops processing and set error flag on invalid response" do
        state = @flow.state_for_responses(%w[option-1 fooey option-2])

        expect(state.error?).to be true
        expect(state.current_node.slug).to eq("question-2")
        expect(state.current_question_number).to eq(2)
        expect(state.completed_questions.size).to eq(1)
        expect(state.completed_questions.first.slug).to eq("option-1")
      end
    end
  end
end
