require 'test_helper'
require 'webmock/test_unit'
require 'publisher_api'

class PublisherApiTest < ActiveSupport::TestCase
  
  test "Given a slug, should go get resource from publisher_app" do
    api = PublisherApi.new("http://example.com")

    slug = "a-publication"
    publication = %@{"audiences":[""],
      "slug":"#{slug}",
      "tags":"",
      "updated_at":"2011-07-28T11:53:03+00:00",
      "type":"answer",
      "body":"Something",
      "title":"A publication"}@
    stub_request(:get, "http://example.com/publications/#{slug}.json").to_return(
      :body => publication,:status=>200)     
    
    pub = api.publication_for_slug(slug)

    assert_equal "Something",pub.body
  end

  test "Should optionally accept an edition id" do
    api = PublisherApi.new("http://example.com")

    slug = "a-publication"
    publication = %@{"audiences":[""],
      "slug":"#{slug}",
      "tags":"",
      "updated_at":"2011-07-28T11:53:03+00:00",
      "type":"answer",
      "body":"Something",
      "title":"A publication"}@
    stub_request(:get, "http://example.com/publications/#{slug}.json?edition=678").to_return(
      :body => publication,:status=>200)     
    
    pub = api.publication_for_slug(slug,{:edition => 678})
  end

  test "Should fetch and parse json into hash" do
     api = PublisherApi.new("http://example.com")
     url = "http://example.com/some.json"
     stub_request(:get, url).to_return(
      :body => "{}",:status=>200) 
     assert_equal Hash,api.fetch_json(url).class
  end

  test "Should return nil if 404 returned from endpoint" do
     api = PublisherApi.new("http://example.com")
     url = "http://example.com/some.json"
     stub_request(:get, url).to_return(
      :body => "{}",:status=>404) 
     assert_nil api.fetch_json(url)
  end

  test "Should construct correct url for a slug" do
    api = PublisherApi.new("http://example.com")
    assert_equal "http://example.com/publications/slug.json", api.url_for_slug("slug")
  end

  def publication_with_parts(slug)
    publication = %@{"audiences":[""],
      "slug":"#{slug}",
      "tags":"",
      "updated_at":"2011-07-28T11:53:03+00:00",
      "type":"guide",
      "body":"Something",
      "parts" : [
      {
         "body" : "You may be financially protected",
         "number" : 1,
         "slug" : "introduction",
         "title" : "Introduction"
      },
      {
         "body" : "All companies selling packag",
         "number" : 2,
         "slug" : "if-you-booked-a-package-holiday",
         "title" : "If you booked a package holiday"
      },
      {
         "body" : "##Know your rights when you b",
         "number" : 3,
         "slug" : "if-you-booked-your-trip-independently",
         "title" : "If you booked your trip independently"
      }],
      "title":"A publication"}@

  end

  test "Parts should be deserialised into whole objects" do
    api = PublisherApi.new("http://example.com")
    slug = "a-publication"
    publication = publication_with_parts(slug)
    stub_request(:get, "http://example.com/publications/#{slug}.json").to_return(
      :body => publication,:status=>200)     
    
    pub = api.publication_for_slug(slug)
    assert_equal 3, pub.parts.size
    assert_equal "introduction", pub.parts.first.slug
  end

  test "A publication with parts should have part-specific methods" do
    api = PublisherApi.new("http://example.com")
    slug = "a-publication"
    publication = publication_with_parts(slug)
    stub_request(:get, "http://example.com/publications/#{slug}.json").to_return(
      :body => publication,:status=>200)     
    
    pub = api.publication_for_slug(slug)
    assert_equal pub.part_index("introduction"),0
  end

  test "Updated at should be a time on deserialisation" do
    api = PublisherApi.new("http://example.com")
    slug = "a-publication"
    publication = publication_with_parts(slug)
    stub_request(:get, "http://example.com/publications/#{slug}.json").to_return(
      :body => publication,:status=>200)     
    
    pub = api.publication_for_slug(slug)
    assert_equal Time, pub.updated_at.class
  end

end
