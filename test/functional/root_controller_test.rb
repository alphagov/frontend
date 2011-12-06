require 'test_helper'
require 'gds_api/part_methods'

class RootControllerTest < ActionController::TestCase

  def mock_api(table)
    api = mock()
    table.each { |slug,pub|
      api.expects(:publication_for_slug).with(slug,{}).returns pub
      pub.extend(GdsApi::PartMethods) if pub && pub.parts
    }
    api
  end

  def mock_artefact_api(table)
    mock().tap do |api|
      table.each do |slug, artefact|
        api.stubs(:artefact_for_slug).with(slug).returns artefact
      end
    end
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  test "should return a 404 if api returns nil" do
    @controller.stubs(:api).returns mock_api("a-slug" => nil)
    @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => nil)
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug"
  end

  test "should choose template based on type of publication" do
    @controller.stubs(:api).returns mock_api(
      "a-slug" => OpenStruct.new(:type=>"answer"))
    @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.expects(:render).with("answer")
    get :publication, :slug => "a-slug"
  end

  test "we can output text from the json easter eggs file" do
    @controller.stubs(:api).returns mock_api(
      "planning-permission" => OpenStruct.new(:type => "answer", :slug => "planning-permission"))
    @controller.stubs(:artefact_api).returns mock_artefact_api('planning-permission' => OpenStruct.new)
    get :publication, :slug => "planning-permission"
    assert @response.body.include? "But Mr Dent"
  end

  test "should pass edition parameter on to api to provide preview" do
     edition_id = '123'
     api = mock()
     api.expects(:publication_for_slug).with("a-slug", {:edition => '123'}).returns(
        OpenStruct.new(:type => "answer"))
     @controller.stubs(:api).returns api
     @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => OpenStruct.new)
     prevent_implicit_rendering
     @controller.stubs(:render)
     get :publication, :slug => "a-slug", :edition => edition_id
  end

  test "should return 404 if full slug doesn't match" do
    api = mock()
    api.expects(:publication_for_slug).with("a-slug", {}).returns(
       OpenStruct.new(:type=>"answer"))
    @controller.stubs(:api).returns api
    @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug", :part => "evil"
  end

  test "should return video view when asked if guide has video" do
    api = mock()
    api.expects(:publication_for_slug).with("a-slug", {}).returns(
       OpenStruct.new(:type=>"guide", :video_url => "bob"))
    @controller.stubs(:api).returns api
    @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, :slug => "a-slug", :part => "video"
  end                                  
  
  test "should return print view" do
    api = mock()
    api.expects(:publication_for_slug).with("a-slug", {}).returns(
       OpenStruct.new(:type=>"guide"))
    @controller.stubs(:api).returns api
    @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.stubs(:render).with("guide_print", { :layout => 'print' })
    get :publication, :slug => "a-slug", :part => "print"
  end 

  test "should return 404 if guide has no video" do
    api = mock()
    api.expects(:publication_for_slug).with("a-slug", {}).returns(
       OpenStruct.new(:type=>"guide"))
    @controller.stubs(:api).returns api
    @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug", :part => "video"
  end

  test "should not pass edition parameter on to api if it's blank" do
     edition_id = ''
     api = mock()
     api.expects(:publication_for_slug).with("a-slug", {}).returns(OpenStruct.new(:type=>"answer"))
     @controller.stubs(:api).returns api
     @controller.stubs(:artefact_api).returns mock_artefact_api('a-slug' => OpenStruct.new)
     prevent_implicit_rendering
     @controller.stubs(:render)
     get :publication, :slug => "a-slug",:edition => edition_id
  end

  test "should pass specific and general variables to template" do
    @controller.stubs(:api).returns mock_api(
      "c-slug" => OpenStruct.new(:type=>"answer",:name=>"THIS"))
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug"
    assert_equal "THIS", assigns["publication"].name
    assert_equal "THIS", assigns["answer"].name
    assert_equal "c-slug", assigns["slug"]
  end

  test "Shouldn't try to identify councils on answers" do
    @controller.stubs(:api).returns mock_api(
      "c-slug" => OpenStruct.new(:type=>"answer",:name=>"THIS"))
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)
    assert_raises RecordNotFound do
      post :identify_council, :slug => "c-slug"
    end
  end

  test "Should redirect to transaction if no geo header" do
      api = mock_api(
      "c-slug" => OpenStruct.new(:type=>"local_transaction",:name=>"THIS"))
      request.env.delete("HTTP_X_GOVGEO_STACK")
      api.expects(:council_for_transaction).with(anything,[])

      @controller.stubs(:api).returns api
      @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)
      post :identify_council, :slug => "c-slug"

      assert_redirected_to publication_path(:slug=>"c-slug")
  end

  include Rack::Geo::Utils
  test "Should redirect to new path if councils found" do
     api = mock_api( "c-slug" => OpenStruct.new(
          :type=>"local_transaction",
          :name=>"THIS"))
     @controller.stubs(:api).returns api
     @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)

     stack = encode_stack({'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]})
     request.env["HTTP_X_GOVGEO_STACK"] = stack
     api.expects(:council_for_transaction).with(anything,[1,2,3]).returns(21)

     post :identify_council, :slug => "c-slug"
     assert_redirected_to publication_path(:slug=>"c-slug",:snac=>"21")
  end

  test "Should set message if no council for local transaction" do
    api = mock_api( "c-slug" => OpenStruct.new(
         :type=>"local_transaction",
         :name=>"THIS"))
    @controller.stubs(:api).returns api
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)

    stack = encode_stack({'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]})
    request.env["HTTP_X_GOVGEO_STACK"] = stack
    api.expects(:council_for_transaction).with(anything,[1,2,3]).returns(nil)

    post :identify_council, :slug => "c-slug"
    assert_redirected_to publication_path(:slug=>"c-slug")
    assert_equal "No details of a provider of that service in your area are available", flash[:no_council]
  end

  test "objects with parts should get first part selected by default" do
     @controller.stubs(:api).returns mock_api(
      "c-slug" => OpenStruct.new({:type=>"answer",
                                  :name=>"THIS",
                                  :parts => [
                                    OpenStruct.new(:slug=>"a",:name=>"AA"),
                                    OpenStruct.new(:slug=>"b",:name=>"BB")
                                ]})) 
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug"
    assert_equal "AA", assigns["part"].name
  end

  test "should return a 404 if slug exists but part doesn't" do
    @controller.stubs(:api).returns mock_api(
      "c-slug" => OpenStruct.new({:type=>"answer",
                                  :name=>"THIS",
                                  :parts => [
                                    OpenStruct.new(:slug=>"a",:name=>"AA"),
                                    OpenStruct.new(:slug=>"b",:name=>"BB")
                                ]}))
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "c-slug", :part => "c"
  end

  test "objects should have specified parts selected" do
    @controller.stubs(:api).returns mock_api(
      "c-slug" => OpenStruct.new({:type=>"answer",
                                  :name=>"THIS",
                                  :parts => [
                                    OpenStruct.new(:slug=>"a",:name=>"AA"),
                                    OpenStruct.new(:slug=>"b",:name=>"BB")
                                ]})) 
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug", :part => "b"
    assert_equal "BB", assigns["part"].name
  end

end
