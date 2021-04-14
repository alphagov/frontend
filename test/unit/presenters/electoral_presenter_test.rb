require "test_helper"

class ElectoralPresenterTest < ActiveSupport::TestCase
  def electoral_response
    path = Rails.root.join("test/fixtures/electoral-result.json")
    fixture = File.read(path)
    JSON.parse(fixture)
  end

  def electoral_presenter
    @electoral_presenter ||= ElectoralPresenter.new(electoral_response)
  end

  context "exposing attributes from the json payload" do
    ElectoralPresenter::EXPECTED_KEYS.each do |exposed_attribute|
      should "expose value of #{exposed_attribute} from payload via a method" do
        assert electoral_presenter.respond_to? exposed_attribute
        assert_equal electoral_response[exposed_attribute], electoral_presenter.send(exposed_attribute)
      end
    end
  end
end
