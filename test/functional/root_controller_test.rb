require 'test_helper'
require 'gds_api/part_methods'

class RootControllerTest < ActionController::TestCase

  def mock_api(table)
    api = mock()
    table.each { |slug,pub|
      api.stubs(:publication_for_slug).with(slug,{}).returns(pub)
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
    @controller.stubs(:api).returns mock_api("a-slug" => OpenStruct.new(:type=>"guide", :name=>"THIS"))
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
  end

  test "Should redirect to transaction if no geo header" do
    api = mock_api("c-slug" => OpenStruct.new(:type => "local_transaction", :name => "THIS"))
    request.env.delete("HTTP_X_GOVGEO_STACK")
    api.expects(:council_for_transaction).with(anything,[])

    @controller.stubs(:api).returns api
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)
    post :identify_council, :slug => "c-slug"

    assert_redirected_to publication_path(:slug => "c-slug", :part => 'not_found')
  end

  test "should expose artefact details in header" do
    artefact = OpenStruct.new(
      section: "rhubarb",
      need_id: 42,
      kind:    "answer"
    )
    @controller.stubs(:api).returns mock_api("slug" => OpenStruct.new)
    @controller.stubs(:artefact_api).returns mock_artefact_api("slug" => artefact)
    @controller.stubs(:render)

    get :publication, :slug => "slug"

    assert_equal "rhubarb", @response.headers["X-Slimmer-Section"]
    assert_equal "42",      @response.headers["X-Slimmer-Need-ID"].to_s
    assert_equal "answer",  @response.headers["X-Slimmer-Format"]
  end

  test "should set proposition to citizen" do
    artefact = OpenStruct.new
    @controller.stubs(:api).returns mock_api("slug" => OpenStruct.new)
    @controller.stubs(:artefact_api).returns mock_artefact_api("slug" => artefact)
    @controller.stubs(:render)

    get :publication, :slug => "slug"

    assert_equal "citizen", @response.headers["X-Slimmer-Proposition"]
  end

  include Rack::Geo::Utils
  include GdsApi::JsonUtils
  test "Should redirect to new path if councils found" do
    full_details = {
      :type => "local_transaction",
      :name => "THIS",
      :authority => {
        :lgils => [
          { :url => "http://www.haringey.gov.uk/something-you-want-to-do" }
        ]
      }
    }

    basic_response = to_ostruct(full_details.slice(:type, :name))
    full_response = to_ostruct(full_details)

    @controller.stubs(:api).returns(mock_api("c-slug" => basic_response))
    @controller.api.expects(:council_for_transaction).with(anything, [1,2,3]).returns(21)
    @controller.api.expects(:publication_for_slug).with('c-slug', {:snac => 21}).returns(full_response)

    stack = encode_stack({'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]})
    request.env["HTTP_X_GOVGEO_STACK"] = stack

    post :identify_council, :slug => "c-slug"
    assert_redirected_to "http://www.haringey.gov.uk/something-you-want-to-do"
  end

  test "Should set message if no council for local transaction" do
    api = mock_api( "c-slug" => OpenStruct.new(:type => "local_transaction", :name => "THIS"))
    @controller.stubs(:api).returns api
    @controller.stubs(:artefact_api).returns mock_artefact_api('c-slug' => OpenStruct.new)

    stack = encode_stack({'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]})
    request.env["HTTP_X_GOVGEO_STACK"] = stack
    api.expects(:council_for_transaction).with(anything,[1,2,3]).returns(nil)

    post :identify_council, :slug => "c-slug"
    assert_redirected_to publication_path(:slug => "c-slug", :part => 'not_found')
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
