require "gds_api/test_helpers/asset_manager"

RSpec.describe "CsvPreview", type: :system do
  include GdsApi::TestHelpers::AssetManager

  filename = "filename"
  asset_manager_id = 4321
  asset_media_url_path = "media/#{asset_manager_id}/#{filename}.csv"
  parent_document_base_path = "/government/important-guidance"
  parent_document_url = "https://www.test.gov.uk#{parent_document_base_path}"

  before do
    setup_asset_manager(parent_document_url, asset_manager_id, filename)
    setup_content_item(asset_media_url_path, parent_document_base_path)
  end

  context "when visiting the preview" do
    before { visit "/#{asset_media_url_path}/preview" }

    it "returns a 200 response" do
      expect(page.status_code).to eq(200)
    end

    it "includes a link to the parent document" do
      expect(page).to have_link("See more information about this guidance", href: parent_document_url)
    end

    it "includes the correct asset title from the content item" do
      expect(page).to have_text("Attachment 2")
    end

    it "includes the last updated date" do
      expect(page).to have_text("Updated 27 May 2023")
    end

    it "includes a link to download the CSV file" do
      expect(page).to have_link("Download CSV 2 KB", href: "https://www.gov.uk/#{asset_media_url_path}")
    end

    it "includes a link to the organisation" do
      expect(page).to have_link("Department of Publishing", href: "http://www.dev.gov.uk/government/organisations/department-of-publishing")
    end

    it "includes the type of the parent document" do
      expect(page).to have_text("Guidance")
    end

    it "includes the page title" do
      expect(page).to have_title("Attachment 2 - GOV.UK")
    end

    it "includes the CSV headings" do
      expect(page).to have_selector(".csv-preview__inner th:nth-child(1)", text: "field_1")
      expect(page).to have_selector(".csv-preview__inner th:nth-child(2)", text: "field_2")
      expect(page).to have_selector(".csv-preview__inner th:nth-child(3)", text: "field_3")
    end

    it "includes the CSV content" do
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1) td:nth-child(1)", text: "Value1")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1) td:nth-child(2)", text: "Value2")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1) td:nth-child(3)", text: "Value3")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(2) td:nth-child(1)", text: "Value1")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(2) td:nth-child(2)", text: "Value2")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(2) td:nth-child(3)", text: "Value3")
    end

    it "truncates at 50 columns" do
      expect(page).to have_selector(".csv-preview__inner th:nth-child(50)", text: "field_50")
      expect(page).not_to have_selector(".csv-preview__inner th:nth-child(51) td:nth-child(3)", text: "field_51")
    end

    it "truncates at 1000 rows" do
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1000) td:nth-child(1)", text: "Value1")
      expect(page).not_to have_selector(".csv-preview__inner tr:nth-child(1001) td:nth-child(1)", text: "Value1")
    end

    it "includes truncation notice, if necessary" do
      expect(page).to have_text("Download the file to see all the information")
    end
  end

  context "when visiting the preview with special characters in filename" do
    before do
      special_characters_filename = "filename+"
      special_characters_url_path = "media/#{asset_manager_id}/#{special_characters_filename}.csv"
      setup_asset_manager(parent_document_url, asset_manager_id, special_characters_filename)
      setup_content_item(special_characters_url_path, parent_document_base_path)
      visit "/#{special_characters_url_path}/preview"
    end

    it "returns a 200 response" do
      expect(page.status_code).to eq(200)
    end
  end

  context "when visiting the preview with malformed CSV" do
    before do
      setup_asset_manager(parent_document_url, asset_manager_id, filename, malformed: true)
      setup_content_item(asset_media_url_path, parent_document_base_path)
      visit "/#{asset_media_url_path}/preview"
    end

    it "returns a 200 response" do
      expect(page.status_code).to eq(200)
    end

    it "includes the error message" do
      expect(page).to have_text("This CSV cannot be viewed online.")
    end

    context "when visiting the preview that redirects to other asset" do
      before do
        setup_asset_manager(parent_document_url, asset_manager_id, filename, malformed: true, asset_deleted: true)
        setup_content_item(asset_media_url_path, parent_document_base_path)
        visit "/#{asset_media_url_path}/preview"
      end

      it "returns a 410 response" do
        expect(page.status_code).to eq(410)
      end
    end
  end

  context "when visiting the preview with nonconvertible characters in the CSV" do
    before do
      setup_asset_manager(parent_document_url, asset_manager_id, filename, nonconvertible: true)
      setup_content_item(asset_media_url_path, parent_document_base_path)
      visit "/#{asset_media_url_path}/preview"
    end

    it "returns a 200 response" do
      expect(page.status_code).to eq(200)
    end

    it "includes the error message" do
      expect(page).to have_text("This CSV cannot be viewed online.")
    end
  end

  context "when the asset is draft and not served from the draft host" do
    before do
      asset_manager_response = { id: "https://asset-manager.dev.gov.uk/assets/foo", parent_document_url:, draft: true }
      stub_asset_manager_has_an_asset(asset_manager_id, asset_manager_response, "/#{filename}.csv")
      visit "/#{asset_media_url_path}/preview"
    end

    it "redirects to the draft assets host" do
      expect(current_url).to eq("http://draft-assets.dev.gov.uk/#{asset_media_url_path}/preview")
    end
  end

  context "when the asset does not exist" do
    before do
      asset_manager_id_2 = 9876
      stub_asset_manager_does_not_have_an_asset(asset_manager_id_2)
      visit "/media/#{asset_manager_id_2}/#{filename}-2.csv/preview"
    end

    it "returns a 404 response" do
      expect(page.status_code).to eq(404)
    end
  end

  context "when asset manager returns a 403 response" do
    before do
      filename = "filename-2"
      asset_media_url_path = "media/#{asset_manager_id}/#{filename}.csv"
      setup_asset_manager(parent_document_url, asset_manager_id, filename, media_code: 403)
      setup_content_item(asset_media_url_path, parent_document_base_path)
      visit "/media/#{asset_manager_id}/#{filename}.csv/preview"
    end

    it "returns a 403 response" do
      expect(page.status_code).to eq(403)
      expect(page).to have_text("You are not authorised to see the preview of this CSV file")
    end
  end

  context "when the asset is in windows-1252 encoding" do
    before do
      csv_file = generate_test_csv(51, 1010).encode("windows-1252")
      stub_request(:get, "#{Plek.find('asset-manager')}/#{asset_media_url_path}").to_return(body: csv_file, status: 200)
      visit "/#{asset_media_url_path}/preview"
    end

    it "includes the CSV headings" do
      expect(page).to have_selector(".csv-preview__inner th:nth-child(1)", text: "field_1")
      expect(page).to have_selector(".csv-preview__inner th:nth-child(2)", text: "field_2")
      expect(page).to have_selector(".csv-preview__inner th:nth-child(3)", text: "field_3")
    end

    it "includes the CSV content" do
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1) td:nth-child(1)", text: "Value1")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1) td:nth-child(2)", text: "Value2")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1) td:nth-child(3)", text: "Value3")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(2) td:nth-child(1)", text: "Value1")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(2) td:nth-child(2)", text: "Value2")
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(2) td:nth-child(3)", text: "Value3")
    end

    it "truncates at 50 columns" do
      expect(page).to have_selector(".csv-preview__inner th:nth-child(50)", text: "field_50")
      expect(page).not_to have_selector(".csv-preview__inner th:nth-child(51) td:nth-child(3)", text: "field_51")
    end

    it "truncates at 1000 rows" do
      expect(page).to have_selector(".csv-preview__inner tr:nth-child(1000) td:nth-child(1)", text: "Value1")
      expect(page).not_to have_selector(".csv-preview__inner tr:nth-child(1001) td:nth-child(1)", text: "Value1")
    end
  end

  it "gets asset from media endpoint" do
    setup_asset_manager(parent_document_url, asset_manager_id, filename)
    setup_content_item(asset_media_url_path, parent_document_base_path)
    visit "/#{asset_media_url_path}/preview"

    expect(page).to have_title("Attachment 2 - GOV.UK")
  end

  def setup_asset_manager(parent_document_url, asset_manager_id, filename = nil, malformed: false, nonconvertible: false, asset_deleted: false, media_code: 200)
    asset_manager_response = { id: "https://asset-manager.dev.gov.uk/assets/foo", parent_document_url:, deleted: asset_deleted }
    stub_asset_manager_has_an_asset(asset_manager_id, asset_manager_response, filename)
    csv_file = if malformed
                 " \"Field 1\"\n"
               else
                 nonconvertible ? "\x8D\n" : generate_test_csv(51, 1010)
               end
    stub_request(:get, "#{Plek.find('asset-manager')}/media/#{asset_manager_id}/#{filename}.csv").to_return(body: csv_file, status: media_code)
  end

  def setup_content_item(non_legacy_url_path, parent_document_base_path)
    filename = non_legacy_url_path.split("/").last
    content_item = {
      base_path: parent_document_base_path,
      document_type: "guidance",
      public_updated_at: "2023-05-27T08:00:07.000+00:00",
      details: {
        attachments: [
          { title: "Attachment 1", filename: "file.csv", url: "https://www.gov.uk/media/5678/file.csv", file_size: "1024" },
          { title: "Attachment 2", filename:, url: "https://www.gov.uk/#{non_legacy_url_path}", file_size: "2048" },
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
