RSpec.describe "Service Manual guide" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide") }
    let(:base_path) { content_store_response.fetch("base_path") }

    describe "with default content_store_response state" do
      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays the page" do
        expect(page.status_code).to eq(200)
      end

      it "service manual guide shows content owners" do
        within(".app-metadata--heading") do
          expect(page).to have_link("Agile delivery community")
        end
      end

      it "the breadcrumb contains the topic" do
        within(".gem-c-breadcrumbs") do
          expect(page).to have_link("Service manual")
          expect(page).to have_link("Agile")
        end
      end

      it "does not display the description for a normal guide" do
        expect(page).not_to have_css(".app-page-header__summary")
      end

      it "displays a link to give feedback" do
        expect(page).to have_link("Give feedback about this page")
      end
    end

    describe "with non-default content_store_response state" do
      context "when rendering the published dates component" do
        let(:content_store_response) { GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide") }

        before do
          content_store_response["details"]["first_public_at"] = "2015-01-01T15:00:00Z"
          stub_content_store_has_item(base_path, content_store_response)
          visit base_path
        end

        it "shows the time it was published if it has been published" do
          within(".gem-c-published-dates") do
            expect(page).to have_text("Published 1 January 2015")
          end
        end

        it "displays the published date of the most recent change" do
          within(".gem-c-published-dates") do
            expect(page).to have_text("Last updated 9 October 2015")
          end
        end

        it "displays the most recent change history for a guide" do
          within(".gem-c-published-dates") do
            expect(page).to have_content("This is our latest change")
          end
        end

        it "displays the change history for a guide" do
          within(".gem-c-published-dates") do
            expect(page).to have_content("This is another change")
            expect(page).to have_content("Guidance first published")
          end
        end

        it "omits the latest change and previous change if the guide has no history" do
          content_store_response["details"]["change_history"] = []
          stub_content_store_has_item(base_path, content_store_response)
          visit base_path

          within(".gem-c-published-dates") do
            expect(page).not_to have_content("show all updates")
            expect(page).not_to have_css(".gem-c-published-dates__toggle")
          end
        end
      end

      it "service manual guide does not show published by" do
        content_store_response = GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide_community")
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".gem-c-metadata") do
          expect(page).not_to have_content("Published by")
        end
      end

      it "displays the description for a point" do
        content_store_response = GovukSchemas::Example.find("service_manual_guide", example_name: "point_page")
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".app-page-header__summary") do
          expect(page).to have_content("Research to develop a deep knowledge of who the service users are")
        end
      end
    end
  end
end
