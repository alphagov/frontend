require_relative "../test_helper"

class SimpleSmartAnswersRoutingTest < ActionDispatch::IntegrationTest
  should "route the start page to the root controller" do
    assert_recognizes( {:controller => "root", :action => "publication", :slug => "fooey"}, "/fooey")
  end

  context "routes in a flow" do
    should "route to the start of a flow" do
      assert_routing "/fooey/y", :controller => "simple_smart_answers", :action => "flow", :slug => "fooey"
    end

    should "route the the second question in a flow" do
      assert_routing "/fooey/y/answer-1", :controller => "simple_smart_answers", :action => "flow", :slug => "fooey", :responses => "answer-1"
    end

    should "route the the a question deeper in a flow" do
      assert_routing "/fooey/y/answer-1/2013-06-26/no",
        :controller => "simple_smart_answers", :action => "flow", :slug => "fooey", :responses => "answer-1/2013-06-26/no"
    end

    should "have json variants of routes" do
      assert_routing "/fooey/y/answer-1/2013-06-26/no.json",
        :controller => "simple_smart_answers", :action => "flow", :slug => "fooey", :responses => "answer-1/2013-06-26/no", :format => "json"
    end
  end
end
