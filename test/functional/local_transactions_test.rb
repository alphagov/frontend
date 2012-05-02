require 'test_helper'
require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)
require 'gds_api/part_methods'
require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/panopticon'

class LocalTransactionsTest < ActionController::TestCase

  tests RootController
  include Rack::Geo::Utils

  def authority_json(snac, name = nil, tier = 'unitary')
    {
      "snac" => snac.to_s,
      "name" => name || "Authority #{snac}",
      "tier" => tier
    }
  end

  def interaction_json(lgsl, lgil, url, authority = nil)
    {
      "lgsl_code" => lgsl,
      "lgil_code" => lgil,
      "url" => url,
      "authority" => authority || authority_json(1)
    }
  end

  test "Should redirect to new path if councils found" do
    councils = {'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]}
    request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils

    councils['council'].each do |c|
      panopticon_has_metadata({'slug' => 'c-slug', 'id' => '12345'})
      publication_exists_for_snac(c['ons'], {
        'slug' => 'c-slug',
        'type' => "local_transaction",
        'name' => "THIS",
        "interaction" =>
          interaction_json(524, 8, "http://www.haringey.gov.uk/something-you-want-to-do")
      })
    end

    get :publication, :slug => "c-slug"
    assert_redirected_to "http://www.haringey.gov.uk/something-you-want-to-do"
  end

  test "Should select the first council which provides the service" do
    councils = {'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]}
    request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils

    panopticon_has_metadata({'slug' => 'c-slug', 'id' => '12345'})

    publication_exists_for_snac(councils['council'][0]['ons'], {
      'slug' => 'c-slug',
      'type' => "local_transaction",
      'name' => "THIS",
    })

    publication_exists_for_snac(councils['council'][1]['ons'], {
      'slug' => 'c-slug',
      'type' => "local_transaction",
      'name' => "THIS",
      'interaction' =>
        interaction_json(524, 8, "http://www.haringey.gov.uk/something-you-want-to-do",
          authority_json(1, "Haringey Council"))
    })

    publication_exists_for_snac(councils['council'][2]['ons'], {
      'slug' => 'c-slug',
      'type' => "local_transaction",
      'name' => "THIS",
      "interaction" =>
        interaction_json(524, 8, "http://www.another.gov.uk/something-you-want-to-do",
          authority_json(1, "Another Council"))
    })

    get :publication, :slug => "c-slug"
    assert_redirected_to "http://www.haringey.gov.uk/something-you-want-to-do"
  end

  test "Should allow the councils to be overridden by council_ons_codes param" do
    # The secondary lookups pass a fuzzy lat/long which isn't precise enough to always
    # accurately identify the correct council, especially if the postcode is close
    # to a council boundary. However during the initial lookup the geo cookie has
    # the data recorded in it, so we can use that.
    councils = {'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]}
    request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils

    panopticon_has_metadata({'slug' => 'c-slug', 'id' => '12345'})

    publication_exists_for_snac(456, {
      'slug' => 'c-slug',
      'type' => "local_transaction",
      'name' => "THIS",
      "interaction" =>
        interaction_json(524, 8, "http://www.another.gov.uk/something-you-want-to-do",
          authority_json(456, "Another Council"))
    })

    publication_exists_for_snac(789, {
      'slug' => 'c-slug',
      'type' => "local_transaction",
      'name' => "THIS",
      "interaction" =>
        interaction_json(524, 8, "http://irrelevant",
          authority_json(789, "Irrelevant")),
    })

    get :publication, :slug => "c-slug", council_ons_codes: [456, 789]
    assert_redirected_to "http://www.another.gov.uk/something-you-want-to-do"
  end

  test "Should not show error message if no postcode submitted" do
    publication_exists_for_snac(1234, {"slug" => "c-slug", "type" => "local_transaction", "name" => "THIS"})
    panopticon_has_metadata('slug' => 'c-slug', 'id' => '12345')

    get :publication, :slug => 'c-slug'
    assert response.body.include?("error-notification hidden")
  end

  test "Should set message if no council for local transaction" do
    councils = {'council'=>[{'ons'=>1}]}
    request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils

    publication_exists_for_snac(1234, {"slug" => "c-slug", "type" => "local_transaction", "name" => "THIS"})
    panopticon_has_metadata('slug' => 'c-slug', 'id' => '12345')

    stub_request(:get, "#{PUBLISHER_ENDPOINT}/publications/c-slug.json?snac=1").to_return(:body => JSON.dump({"slug" => "c-slug", "type" => "local_transaction", "name" => "THIS"}))

    get :publication, :slug => "c-slug"
    assert response.body.include? "couldn't find details of a provider"
  end
end