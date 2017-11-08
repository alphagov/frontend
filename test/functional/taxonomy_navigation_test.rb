require "test_helper"

class FakeTaxonomyNavigationController < ApplicationController
  include TaxonomyNavigation
end

class TaxonomyNavigationTest < ActionController::TestCase
  context "Taxonomy Navigation helper" do
    setup do
      @controller = FakeTaxonomyNavigationController.new

      @content_item = {
        'base_path' => [],
        'links' => []
      }
    end

    should "return false if no content item is provided" do
      @content_item = nil

      assert_equal(false, @controller.should_present_taxonomy_navigation?(@content_item))
    end

    should "return true if page is tagged to worldwide taxonomy" do
      @content_item['base_path'] = "/world"
      @content_item['links'] = {
        'mainstream_browse_pages' => [{
          'content_id' => 'something'
        }],
        'taxons' => [{
          'title' => 'A Taxon',
          'base_path' => '/world'
        }]
      }

      assert_equal(true, @controller.should_present_taxonomy_navigation?(@content_item))
    end

    should "return true if page is tagged to taxonomy and not mainstream browse" do
      @content_item['links'] = {
        'taxons' => [{
          'title' => 'A Taxon',
          'base_path' => '/a-taxon'
        }]
      }

      assert_equal(true, @controller.should_present_taxonomy_navigation?(@content_item))
    end

    should "return false if page is tagged to mainstream browse and not taxonomy" do
      @content_item['links'] = {
        'mainstream_browse_pages' => [{
          'content_id' => 'something'
        }]
      }

      assert_equal(false, @controller.should_present_taxonomy_navigation?(@content_item))
    end

    should "return false if page is tagged to mainstream browse and non-worldwide taxonomy" do
      @content_item['links'] = {
        'mainstream_browse_pages' => [{
          'content_id' => 'something'
        }],
        'taxons' => [{
          'title' => 'A Taxon',
          'base_path' => '/not-worldwide'
        }]
      }

      assert_equal(false, @controller.should_present_taxonomy_navigation?(@content_item))
    end


    should "return true if page is tagged to mainstream browse and worldwide taxonomy" do
      @content_item['links'] = {
        'mainstream_browse_pages' => [{
          'content_id' => 'something'
        }],
        'taxons' => [{
          'title' => 'A Taxon',
          'base_path' => '/world'
        }]
      }

      assert_equal(true, @controller.should_present_taxonomy_navigation?(@content_item))
    end
  end
end
