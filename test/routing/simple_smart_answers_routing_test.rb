require "test_helper"

class SimpleSmartAnswersRoutingTest < ActionDispatch::IntegrationTest
  context "for the start page" do
    setup do
      content_store_has_page("fooey", schema: "simple_smart_answer")
    end

    should "route the start page to the SimpleSmartAnswer controller" do
      assert_recognizes({ controller: "simple_smart_answers", action: "show", slug: "fooey" }, "/fooey")
    end
  end

  context "routes in a flow" do
    should "route to the start of a flow" do
      assert_routing "/fooey/y", controller: "simple_smart_answers", action: "flow", slug: "fooey"
    end

    should "route the the second question in a flow" do
      assert_routing "/fooey/y/answer-1", controller: "simple_smart_answers", action: "flow", slug: "fooey", responses: "answer-1"
    end

    should "route the the a question deeper in a flow" do
      assert_routing "/fooey/y/answer-1/2013-06-26/no",
                     controller: "simple_smart_answers",
                     action: "flow",
                     slug: "fooey",
                     responses: "answer-1/2013-06-26/no"
    end

    should "have json variants of routes" do
      assert_routing "/fooey/y/answer-1/2013-06-26/no.json",
                     controller: "simple_smart_answers",
                     action: "flow",
                     slug: "fooey",
                     responses: "answer-1/2013-06-26/no",
                     format: "json"
    end
  end
end
