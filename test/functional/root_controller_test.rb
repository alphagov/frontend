require 'test_helper'

class RootControllerTest < ActionController::TestCase

  def mock_api(table)
    api = mock()
    table.each { |slug,pub|
      api.expects(:publication_for_slug).with(slug,{}).returns pub
      pub.extend(PartMethods) if pub && pub.parts
    }
    api
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  test "should return a 404 if api returns nil" do
    @controller.stubs(:api).returns mock_api("a-slug" => nil)
    
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug"
  end
   
  test "should choose template based on type of publication" do
    @controller.stubs(:api).returns mock_api(
      "a-slug" => OpenStruct.new(:type=>"answer"))
    
    prevent_implicit_rendering
    @controller.expects(:render).with("answer")
    get :publication, :slug => "a-slug"
  end

  test "should pass edition parameter on to api to provide preview" do
     edition_id = '123'
     api = mock()
     api.expects(:publication_for_slug).with("a-slug",{:edition=>'123'}).returns(
        OpenStruct.new(:type=>"answer"))
     @controller.stubs(:api).returns api
     prevent_implicit_rendering
     @controller.stubs(:render)
     get :publication, :slug => "a-slug",:edition => edition_id
  end
  
  test "should not pass edition parameter on to api if it's blank" do
     edition_id = ''
     api = mock()
     api.expects(:publication_for_slug).with("a-slug", {}).returns(OpenStruct.new(:type=>"answer"))
     @controller.stubs(:api).returns api
     prevent_implicit_rendering
     @controller.stubs(:render)
     get :publication, :slug => "a-slug",:edition => edition_id
  end

  test "should pass specific and general variables to template" do
    @controller.stubs(:api).returns mock_api(
      "c-slug" => OpenStruct.new(:type=>"answer",:name=>"THIS"))
    
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
      post :identify_council, :slug => "c-slug"

      assert_redirected_to publication_path(:slug=>"c-slug")
  end

  include Rack::Geo::Utils 
  test "Should redirect to new path if councils found" do
     api = mock_api( "c-slug" => OpenStruct.new(
          :type=>"local_transaction",
          :name=>"THIS"))
     @controller.stubs(:api).returns api

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
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug"
    assert_equal "AA", assigns["part"].name
  end

  test "objects should have specified parts selected" do
    @controller.stubs(:api).returns mock_api(
      "c-slug" => OpenStruct.new({:type=>"answer",
                                  :name=>"THIS",
                                  :parts => [
                                    OpenStruct.new(:slug=>"a",:name=>"AA"),
                                    OpenStruct.new(:slug=>"b",:name=>"BB")
                                ]})) 
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug", :part => "b"
    assert_equal "BB", assigns["part"].name
  end

end
