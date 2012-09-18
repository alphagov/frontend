require_relative "../test_helper"

class HelpControllerTest < ActionController::TestCase

  should "setup a dummy artefact for slimmer" do
    @controller.expects(:set_slimmer_dummy_artefact).with(:section_name => 'Help', :section_link => '/help')
    get :index
  end
end
