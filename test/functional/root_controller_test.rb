require 'test_helper'

class RootControllerTest < ActionController::TestCase

  def setup_this_answer
    publication_exists(
      'slug' => 'c-slug',
      'type' => 'answer',
      'name' => 'THIS',
      'parts' => [
        {'slug' => 'a', 'name' => 'AA'},
        {'slug' => 'b', 'name' => 'BB'}
      ]
    )
    panopticon_has_metadata('slug' => 'c-slug', 'id' => '12345')
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  test "should return a 404 if api returns nil" do
    publication_does_not_exist('slug' => 'a-slug')
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug"
  end

  test "should choose template based on type of publication" do
    publication_exists('slug' => 'a-slug', 'type' => 'answer')
    panopticon_has_metadata('slug' => 'a-slug')
    prevent_implicit_rendering
    @controller.expects(:render).with("answer")
    get :publication, :slug => "a-slug"
  end

  test "we can output text from the json easter eggs file" do
    publication_exists('slug' => 'planning-permission', 'type' => 'answer')
    panopticon_has_metadata('slug' => 'planning-permission')
    get :publication, :slug => "planning-permission"
    assert @response.body.include? "But Mr Dent"
  end

  test "should pass edition parameter on to api to provide preview" do
     edition_id = '123'
     api = mock()
     api.expects(:publication_for_slug).with("a-slug", {:edition => '123'}).returns(
        OpenStruct.new(:type => "answer"))
     @controller.stubs(:api).returns api
     panopticon_has_metadata('slug' => 'a-slug')

     prevent_implicit_rendering
     @controller.stubs(:render)
     get :publication, :slug => "a-slug", :edition => edition_id
  end

  test "should return 404 if full slug doesn't match" do
    api = mock()
    api.expects(:publication_for_slug).with("a-slug", {}).returns(
       OpenStruct.new(:type=>"answer"))
    @controller.stubs(:api).returns api
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug", :part => "evil"
  end

  test "should return video view when asked if guide has video" do
    api = mock()
    api.expects(:publication_for_slug).with("a-slug", {}).returns(
       OpenStruct.new(:type=>"guide", :video_url => "bob"))
    @controller.stubs(:api).returns api
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.stubs(:render)
    get :publication, :slug => "a-slug", :part => "video"
  end

  test "should return print view" do
    publication_exists('slug' => 'a-slug', 'type' => 'guide', 'name' => 'THIS')
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.stubs(:render).with("guide_print", { :layout => 'print' })
    get :publication, :slug => "a-slug", :part => "print"
  end 

  test "should return 404 if guide has no video" do
    api = mock()
    api.expects(:publication_for_slug).with("a-slug", {}).returns(
       OpenStruct.new(:type=>"guide"))
    @controller.stubs(:api).returns api
    panopticon_has_metadata('slug' => 'a-slug')

    prevent_implicit_rendering
    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "a-slug", :part => "video"
  end

  test "should not pass edition parameter on to api if it's blank" do
     edition_id = ''
     api = mock()
     api.expects(:publication_for_slug).with("a-slug", {}).returns(OpenStruct.new(:type=>"answer"))
     @controller.stubs(:api).returns api
     panopticon_has_metadata('slug' => 'a-slug')

     prevent_implicit_rendering
     @controller.stubs(:render)
     get :publication, :slug => "a-slug",:edition => edition_id
  end

  test "should pass specific and general variables to template" do
    publication_exists('slug' => 'c-slug', 'type' => 'answer', 'name' => 'THIS')
    panopticon_has_metadata('slug' => 'c-slug')

    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug"
    assert_equal "THIS", assigns["publication"].name
    assert_equal "THIS", assigns["answer"].name
  end

  test "Should redirect to transaction if no geo header" do
    publication_exists('slug' => 'c-slug', 'type' => 'local_transaction', 'name' => 'THIS')
    panopticon_has_metadata('slug' => 'c-slug')

    request.env.delete("HTTP_X_GOVGEO_STACK")
    no_council_for_slug('c-slug')
    post :identify_council, :slug => "c-slug"

    assert_redirected_to publication_path(:slug => "c-slug", :part => 'not_found')
  end

  test "should hard code proposition on the home page" do
    get :index

    assert_equal "citizen", @response.headers["X-Slimmer-Proposition"]
  end

  test "should expose artefact details in header" do
    panopticon_has_metadata('slug' => 'slug', 'section' => "rhubarb", 'need_id' => 42, 'kind' => "answer")
    publication_exists('slug' => 'slug')
    @controller.stubs(:render)

    get :publication, :slug => "slug"

    assert_equal "rhubarb", @response.headers["X-Slimmer-Section"]
    assert_equal "42",      @response.headers["X-Slimmer-Need-ID"].to_s
    assert_equal "answer",  @response.headers["X-Slimmer-Format"]
  end

  test "should set proposition to citizen" do
    publication_exists('slug' => 'slug')
    panopticon_has_metadata('slug' => 'slug', 'id' => '12345')
    @controller.stubs(:render)

    get :publication, :slug => "slug"

    assert_equal "citizen", @response.headers["X-Slimmer-Proposition"]
  end

  test "sets up a default artefact if panopticon isn't available" do
    @controller.artefact_api.stubs(:artefact_for_slug).returns(nil)
    @controller.stubs(:render)
    publication_exists('slug' => 'slug')

    get :publication, slug: "slug"

    assert_equal "missing", @response.headers["X-Slimmer-Section"]
    assert_equal "missing", @response.headers["X-Slimmer-Need-ID"].to_s
    assert_equal "missing", @response.headers["X-Slimmer-Format"]
  end

  test "objects with parts should get first part selected by default" do
    setup_this_answer
    prevent_implicit_rendering

    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug"
    assert_equal "AA", assigns["part"].name
  end

  test "should return a 404 if slug exists but part doesn't" do
    setup_this_answer
    prevent_implicit_rendering

    @controller.expects(:render).with(has_entry(:status=>404))
    get :publication, :slug => "c-slug", :part => "c"
  end

  test "objects should have specified parts selected" do
    setup_this_answer
    prevent_implicit_rendering
    @controller.stubs(:render).with("answer")
    get :publication, :slug => "c-slug", :part => "b"
    assert_equal "BB", assigns["part"].name
  end
end
