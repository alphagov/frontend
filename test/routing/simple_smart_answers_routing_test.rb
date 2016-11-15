require "test_helper"

class SimpleSmartAnswersRoutingTest < ActionDispatch::IntegrationTest
  context "for the start page" do
    setup do
      @artefact = artefact_for_slug('fooey')
      @artefact["format"] = "simple_smart_answer"
      content_api_and_content_store_have_page('fooey', @artefact)
    end

    should "route the start page to the root controller" do
      assert_recognizes({ controller: "root", action: "publication", slug: "fooey" }, "/fooey")
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
        controller: "simple_smart_answers", action: "flow", slug: "fooey", responses: "answer-1/2013-06-26/no"
    end

    should "have json variants of routes" do
      assert_routing "/fooey/y/answer-1/2013-06-26/no.json",
        controller: "simple_smart_answers", action: "flow", slug: "fooey", responses: "answer-1/2013-06-26/no", format: "json"
    end
  end
end
