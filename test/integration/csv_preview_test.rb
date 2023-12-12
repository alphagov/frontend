require "integration_test_helper"
require "gds_api/test_helpers/asset_manager"
require "gds_api/test_helpers/content_store"

class CsvPreviewTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AssetManager
  include GdsApi::TestHelpers::ContentStore

  filename = "filename"
  asset_manager_id = 4321
  asset_media_url_path = "media/#{asset_manager_id}/#{filename}.csv"
  parent_document_base_path = "/government/important-guidance"
  parent_document_url = "https://www.test.gov.uk#{parent_document_base_path}"

  setup do
    setup_asset_manager(parent_document_url, asset_manager_id, filename)

    setup_content_item(asset_media_url_path, parent_document_base_path)
  end

  context "when visiting the preview" do
    setup do
      visit "/#{asset_media_url_path}/preview"
    end

    should "return a 200 response" do
      assert_equal 200, page.status_code
    end

    should "include a link to the parent document" do
      assert page.has_link?("See more information about this guidance", href: parent_document_url)
    end

    should "include the correct asset title from the content item" do
      assert page.has_text?("Attachment 2")
    end

    should "include the last updated date" do
      assert page.has_text?("Updated 27 May 2023")
    end

    should "include a link to download the CSV file" do
      assert page.has_link?("Download CSV 2 KB", href: "https://www.gov.uk/#{asset_media_url_path}")
    end

    should "include a link to the organisation" do
      assert page.has_link?("Department of Publishing", href: "/government/organisations/department-of-publishing")
    end

    should "include the type of the parent document" do
      assert page.has_text?("Guidance")
    end

    should "include the page title" do
      assert page.has_title?("Attachment 2 - GOV.UK")
    end

    should "include the CSV headings" do
      assert_selector ".csv-preview__inner th:nth-child(1)", text: "field_1"
      assert_selector ".csv-preview__inner th:nth-child(2)", text: "field_2"
      assert_selector ".csv-preview__inner th:nth-child(3)", text: "field_3"
    end

    should "include the CSV content" do
      assert_selector ".csv-preview__inner tr:nth-child(1) td:nth-child(1)", text: "Value1"
      assert_selector ".csv-preview__inner tr:nth-child(1) td:nth-child(2)", text: "Value2"
      assert_selector ".csv-preview__inner tr:nth-child(1) td:nth-child(3)", text: "Value3"
      assert_selector ".csv-preview__inner tr:nth-child(2) td:nth-child(1)", text: "Value1"
      assert_selector ".csv-preview__inner tr:nth-child(2) td:nth-child(2)", text: "Value2"
      assert_selector ".csv-preview__inner tr:nth-child(2) td:nth-child(3)", text: "Value3"
    end

    should "truncate at 50 columns" do
      assert_selector ".csv-preview__inner th:nth-child(50)", text: "field_50"
      assert_no_selector ".csv-preview__inner th:nth-child(51) td:nth-child(3)", text: "field_51"
    end

    should "truncate at 1000 rows" do
      assert_selector ".csv-preview__inner tr:nth-child(1000) td:nth-child(1)", text: "Value1"
      assert_no_selector ".csv-preview__inner tr:nth-child(1001) td:nth-child(1)", text: "Value1"
    end
  end

  context "when visiting the preview with special characters in filename" do
    setup do
      special_characters_filename = "filename+"
      special_characters_url_path = "media/#{asset_manager_id}/#{special_characters_filename}.csv"

      setup_asset_manager(parent_document_url, asset_manager_id, special_characters_filename)
      setup_content_item(special_characters_url_path, parent_document_base_path)

      visit "/#{special_characters_url_path}/preview"
    end

    should "return a 200 response" do
      assert_equal 200, page.status_code
    end
  end

  context "when visiting the preview with special characters in the CSV" do
    setup do
      setup_asset_manager(parent_document_url, asset_manager_id, filename, use_special_characters_csv: true)
      setup_content_item(asset_media_url_path, parent_document_base_path)

      visit "/#{asset_media_url_path}/preview"
    end

    should "return a 200 response" do
      assert_equal 200, page.status_code
    end

    should "include the error message" do
      assert page.has_text?("This CSV cannot be viewed online.")
    end

    context "when visiting the preview that redirects to other asset" do
      setup do
        setup_asset_manager(parent_document_url, asset_manager_id, filename, use_special_characters_csv: true, asset_deleted: true)
        setup_content_item(asset_media_url_path, parent_document_base_path)

        visit "/#{asset_media_url_path}/preview"
      end

      should "return a 410 response" do
        assert_equal 410, page.status_code
      end
    end
  end

  context "when the asset is draft and not served from the draft host" do
    setup do
      asset_manager_response = {
        id: "https://asset-manager.dev.gov.uk/assets/foo",
        parent_document_url:,
        draft: true,
      }
      stub_asset_manager_has_an_asset(asset_manager_id, asset_manager_response, "/#{filename}.csv")

      visit "/#{asset_media_url_path}/preview"
    end

    should "redirect to the draft assets host" do
      assert_equal "http://draft-assets.dev.gov.uk/#{asset_media_url_path}/preview", current_url
    end
  end

  context "when the asset does not exist" do
    setup do
      asset_manager_id_2 = 9876
      stub_asset_manager_does_not_have_an_asset(asset_manager_id_2)
      visit "/media/#{asset_manager_id_2}/#{filename}-2.csv/preview"
    end

    should "return a 404 response" do
      assert_equal 404, page.status_code
    end
  end

  context "when asset manager returns a 403 response" do
    setup do
      stub_request(:get, "#{ASSET_MANAGER_ENDPOINT}/media/#{asset_manager_id}/#{filename}-2.csv")
        .to_return(status: 403)
      visit "/media/#{asset_manager_id}/#{filename}-2.csv/preview"
    end

    should "return a 403 response" do
      assert_equal 403, page.status_code
      assert page.has_text?("You are not authorised to see the preview of this CSV file")
    end
  end

  context "when the asset is in windows-1252 encoding" do
    setup do
      csv_file = generate_test_csv(51, 1010).encode("windows-1252")

      stub_request(:get, "#{Plek.find('asset-manager')}/#{asset_media_url_path}")
        .to_return(body: csv_file, status: 200)

      visit "/#{asset_media_url_path}/preview"
    end

    should "include the CSV headings" do
      assert_selector ".csv-preview__inner th:nth-child(1)", text: "field_1"
      assert_selector ".csv-preview__inner th:nth-child(2)", text: "field_2"
      assert_selector ".csv-preview__inner th:nth-child(3)", text: "field_3"
    end

    should "include the CSV content" do
      assert_selector ".csv-preview__inner tr:nth-child(1) td:nth-child(1)", text: "Value1"
      assert_selector ".csv-preview__inner tr:nth-child(1) td:nth-child(2)", text: "Value2"
      assert_selector ".csv-preview__inner tr:nth-child(1) td:nth-child(3)", text: "Value3"
      assert_selector ".csv-preview__inner tr:nth-child(2) td:nth-child(1)", text: "Value1"
      assert_selector ".csv-preview__inner tr:nth-child(2) td:nth-child(2)", text: "Value2"
      assert_selector ".csv-preview__inner tr:nth-child(2) td:nth-child(3)", text: "Value3"
    end

    should "truncate at 50 columns" do
      assert_selector ".csv-preview__inner th:nth-child(50)", text: "field_50"
      assert_no_selector ".csv-preview__inner th:nth-child(51) td:nth-child(3)", text: "field_51"
    end

    should "truncate at 1000 rows" do
      assert_selector ".csv-preview__inner tr:nth-child(1000) td:nth-child(1)", text: "Value1"
      assert_no_selector ".csv-preview__inner tr:nth-child(1001) td:nth-child(1)", text: "Value1"
    end
  end

  should "get asset from media endpoint" do
    setup_asset_manager(parent_document_url, asset_manager_id, filename)
    setup_content_item(asset_media_url_path, parent_document_base_path)

    visit "/#{asset_media_url_path}/preview"
    assert page.has_title?("Attachment 2 - GOV.UK")
  end

  def setup_asset_manager(parent_document_url, asset_manager_id, filename = nil, use_special_characters_csv: false, asset_deleted: false)
    asset_manager_response = {
      id: "https://asset-manager.dev.gov.uk/assets/foo",
      parent_document_url:,
      deleted: asset_deleted,
    }
    stub_asset_manager_has_an_asset(asset_manager_id, asset_manager_response, filename)

    csv_file = if use_special_characters_csv
                 "\xEF\xBB\xBF\"Field 1\",\"Field 2\",\"Field 3 \n(details)\",\"Field 4 (\xC2\xA3m)\"\n\"Value 1\",\"Value 2\",\"Value 3\",\"Value 4 \xC2\xA33.8bn\"\n"
               else
                 generate_test_csv(51, 1010)
               end

    stub_request(:get, "#{Plek.find('asset-manager')}/media/#{asset_manager_id}/#{filename}.csv")
      .to_return(body: csv_file, status: 200)
  end

  def setup_content_item(non_legacy_url_path, parent_document_base_path)
    filename = non_legacy_url_path.split("/").last
    content_item = {
      base_path: parent_document_base_path,
      document_type: "guidance",
      public_updated_at: "2023-05-27T08:00:07.000+00:00",
      details: {
        attachments: [
          {
            title: "Attachment 1",
            filename: "file.csv",
            url: "https://www.gov.uk/media/5678/file.csv",
            file_size: "1024",
          },
          {
            title: "Attachment 2",
            filename:,
            url: "https://www.gov.uk/#{non_legacy_url_path}",
            file_size: "2048",
          },
        ],
      },
      links: {
        organisations: [
          {
            base_path: "/government/organisations/department-of-publishing",
            details: {
              brand: "single-identity",
              logo: {
                crest: "single-identity",
                formatted_title: "Department of Publishing",
              },
            },
          },
        ],
      },
    }
    stub_content_store_has_item(parent_document_base_path, content_item)
  end

  def generate_test_csv(column_count, row_count)
    csv_headers = CSV.generate_line((1..column_count).map { |column_number| "field_#{column_number}" })
    csv_row = CSV.generate_line((1..column_count).map { |column_number| "Value#{column_number}" })
    csv_rows = (1..row_count).map { |_| csv_row }
    ([csv_headers] + csv_rows).join("")
  end
end
