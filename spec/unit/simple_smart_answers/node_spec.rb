module SimpleSmartAnswers
  RSpec.describe Node, type: :model do
    it "has attribute accessors for basic fields" do
      node = Node.new(:a_flow, "kind" => "question", "slug" => "question-1", "title" => "Question 1", "body" => "<p>This is question 1</p>", "options" => [])
      expect(node.kind).to eq("question")
      expect(node.title).to eq("Question 1")
      expect(node.slug).to eq("question-1")
      expect(node.body).to eq("<p>This is question 1</p>")
    end

    describe "#outcome?" do
      it "is true for an outcome node" do
        expect(Node.new(:a_flow, "kind" => "outcome").outcome?).to be true
      end

      it "is false for a question node" do
        expect(Node.new(:a_flow, "kind" => "question").outcome?).to be false
      end
    end

    describe "#options" do
      before do
        @flow = instance_double("Flow", node_for_slug: :a_node)
        @node = Node.new(@flow, "kind" => "question", "slug" => "question-1", "options" => [{ "label" => "Option 1", "slug" => "option-1", "next_node" => "question-2" }, { "label" => "Option 3", "slug" => "option-3", "next_node" => "question-3" }, { "label" => "Option 2", "slug" => "option-2", "next_node" => "question-2" }])
      end

      it "constructs options" do
        expect(@node.options.map(&:label)).to eq(["Option 1", "Option 3", "Option 2"])
        expect(@node.options.map(&:slug)).to eq(%w[option-1 option-3 option-2])
        expect(@node.options.map(&:next_node_slug)).to eq(%w[question-2 question-3 question-2])
        expect(@node.options.first.question).to eq(@node)
      end
    end

    describe "#process_response" do
      before do
        @flow = instance_double("Flow", node_for_slug: :a_node)
        @node = Node.new(@flow, "kind" => "question", "slug" => "question-1", "options" => [{ "label" => "Option 1", "slug" => "option-1", "next_node" => "question-2" }, { "label" => "Option 3", "slug" => "option-3", "next_node" => "question-3" }, { "label" => "Option 2", "slug" => "option-2", "next_node" => "question-2" }])
      end

      it "returns the matching option instance" do
        expect(@node.process_response("option-2").label).to eq("Option 2")
      end

      it "populates the next_node on the returned option" do
        allow(@flow).to receive(:node_for_slug).with("question-2").and_return(:question_2_node)

        expect(@node.process_response("option-2").next_node).to eq(:question_2_node)
      end

      it "raises InvalidResponse if no option matches" do
        expect { @node.process_response("option-4") }.to raise_error(InvalidResponse)
      end

      it "raises InvalidResponse if option points to a non-existent node" do
        allow(@flow).to receive(:node_for_slug).with("question-2").and_return(nil)

        expect { @node.process_response("option-2") }.to raise_error(InvalidResponse)
      end
    end
  end
end
