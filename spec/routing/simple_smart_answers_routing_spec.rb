RSpec.describe "SimpleSmartAnswersRouting", type: :routing do
  include ContentStoreHelpers

  context "for the start page" do
    before { content_store_has_page("fooey", schema: "simple_smart_answer") }

    it "routes the start page to the SimpleSmartAnswer controller" do
      assert_recognizes({ controller: "simple_smart_answers", action: "show", slug: "fooey" }, "/fooey")
    end
  end

  context "routes in a flow" do
    before { content_store_has_page("fooey", schema: "simple_smart_answer") }

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
