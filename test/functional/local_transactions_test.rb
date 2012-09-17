require 'test_helper'
require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)
require 'gds_api/part_methods'
require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/content_api'

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
      content_api_has_an_artefact("c-slug")
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

    content_api_has_an_artefact("c-slug")

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

  test "Should pass the edition parameter on when looking for council details" do
    councils = {'council'=>[{'ons'=>1}]}
    request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils
    snac = councils['council'][0]['ons']

    content_api_has_an_artefact("c-slug")

    details = {slug: 'c-slug', type: 'local_transaction', name: 'THIS'}
    json = JSON.dump(details)
    uri = "#{PUBLISHER_ENDPOINT}/publications/#{details[:slug]}.json"

    stub_request(:get, uri).with(query: {edition: '1'}).
      to_return(:body => json, :status => 200)

    stub_request(:get, uri).with(query: {snac: snac.to_s, edition: '1'}).
      to_return(:body => json, :status => 200)

    get :publication, {slug: "c-slug", edition: '1'}
    assert_requested :get, "#{uri}?snac=#{snac}&edition=1"
  end

  test "Should allow the councils to be overridden by council_ons_codes param" do
    # The secondary lookups pass a fuzzy lat/long which isn't precise enough to always
    # accurately identify the correct council, especially if the postcode is close
    # to a council boundary. However during the initial lookup the geo cookie has
    # the data recorded in it, so we can use that.
    councils = {'council'=>[{'ons'=>1},{'ons'=>2},{'ons'=>3}]}
    request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils

    content_api_has_an_artefact("c-slug")

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
    content_api_has_an_artefact("c-slug")

    get :publication, :slug => 'c-slug'
    assert response.body.include?("error-notification hidden")
  end

  test "Should set message if no council for local transaction" do
    councils = {'council'=>[{'ons'=>1}]}
    request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils

    publication_exists_for_snac(1234, {"slug" => "c-slug", "type" => "local_transaction", "name" => "THIS"})
    content_api_has_an_artefact("c-slug")

    stub_request(:get, "#{PUBLISHER_ENDPOINT}/publications/c-slug.json?snac=1").to_return(:body => JSON.dump({"slug" => "c-slug", "type" => "local_transaction", "name" => "THIS"}))

    get :publication, :slug => "c-slug"
    assert response.body.include? "couldn't find details of a provider"
  end
end