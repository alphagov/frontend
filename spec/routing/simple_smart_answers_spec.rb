RSpec.describe "Simple Smart Answers" do
  include ContentStoreHelpers

  before do
    content_store_has_random_item(base_path: "/fooey", schema: "simple_smart_answer")
  end

  context "when accessing the start page" do
    it "routes the start page to the SimpleSmartAnswer controller" do
      expect(get("/fooey")).to route_to(controller: "simple_smart_answers", action: "show", slug: "fooey")
    end
  end

  context "with routes in a flow" do
    it "routes to the start of a flow" do
      expect(get("/fooey/y")).to route_to(controller: "simple_smart_answers", action: "flow", slug: "fooey")
    end

    it "routes the the second question in a flow" do
      expect(get("/fooey/y/answer-1")).to route_to(controller: "simple_smart_answers", action: "flow", slug: "fooey", responses: "answer-1")
    end

    it "routes the the a question deeper in a flow" do
      expect(get("/fooey/y/answer-1/2013-06-26/no")).to route_to(controller: "simple_smart_answers", action: "flow", slug: "fooey", responses: "answer-1/2013-06-26/no")
    end

    it "has json variants of routes" do
      expect(get("/fooey/y/answer-1/2013-06-26/no.json")).to route_to(controller: "simple_smart_answers", action: "flow", slug: "fooey", responses: "answer-1/2013-06-26/no", format: "json")
    end
  end
end
