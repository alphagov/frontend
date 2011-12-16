require 'test_helper'
require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)
require 'gds_api/part_methods'
require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/panopticon'

class LocalTransactionsTest < ActionController::TestCase

  tests RootController
  include Rack::Geo::Utils
  
  def council_exists_for_slug(input_details, output_details)
    json = JSON.dump(output_details)
    slug = input_details.delete('slug')
    uri = "#{PUBLISHER_ENDPOINT}/local_transactions/#{slug}/verify_snac.json"
    stub_request(:post, uri).with(:body => JSON.dump(input_details), 
      :headers => GdsApi::JsonUtils::REQUEST_HEADERS).
      to_return(:body => json, :status => 200)
  end

  def setup_this_local_transaction
    publication_exists("slug" => "c-slug", "type" => "local_transaction", "name" => "THIS")
    panopticon_has_metadata('slug' => 'c-slug', 'id' => '12345')
  end
  
  def setup_full_transaction_details
    full_details = {
      'slug' => 'c-slug',
      'type' => "local_transaction",
      'name' => "THIS",
      'authority' => {
        'lgils' => [
          { 'url' => "http://www.haringey.gov.uk/something-you-want-to-do" }
        ]
      }
    }
    council_exists_for_slug({'slug' => 'c-slug', 'snac_codes' => [1, 2, 3] }, {snac: 21})
    publication_exists_for_snac(21, full_details)
  end

  test "Should redirect to new path if councils found" do
    setup_full_transaction_details

    stack = encode_stack({'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]})
    request.env["HTTP_X_GOVGEO_STACK"] = stack

    post :identify_council, :slug => "c-slug"
    assert_redirected_to "http://www.haringey.gov.uk/something-you-want-to-do"
  end

  test "Should set message if no council for local transaction" do
    setup_this_local_transaction

    stack = encode_stack({'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]})
    request.env["HTTP_X_GOVGEO_STACK"] = stack
    no_council_for_slug('c-slug')
    post :identify_council, :slug => "c-slug"
    assert_redirected_to publication_path(:slug => "c-slug", :part => 'not_found')
  end
end