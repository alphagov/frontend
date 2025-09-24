RSpec.describe "HTML publication" do
  describe "GET /<document_type>/<slug>" do
    let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "published") }
    let(:base_path) { content_item["base_path"] }

    before do
      stub_content_store_has_item(base_path, content_item)
      visit base_path
    end

    describe "when visiting a html publication" do
      # test "random but valid items do not error" do
      #   assert_nothing_raised { setup_and_visit_random_content_item }
      # end

      # it "has expected elements and contents" do
      #   visit base_path

      #   within ".gem-c-inverse-header" do
      #     format_sub_type = content_item["details"]["format_sub_type"]
      #     expect(page).to have_text(format_sub_type) if format_sub_type.present?
      #     expect(page).to have_text(content_item["title"])

      #     expect(page).to have_text("Published 17 January 2016")
      #   end

      #   within "#contents" do
      #     expect(page).to have_text("Contents")
      #     expect(page).to have_css(".gem-c-contents-list")
      #   end

      #   expect(page).to have_text("The Environment Agency will normally put any responses it receives on the public register. This includes your name and contact details. Tell us if you don’t want your response to be public.")
      # end

      it "renders back to contents elements" do
        expect(page).to have_css(".gem-c-back-to-top-link[href='#contents']")
      end
    end

    describe "when visiting a html publication with metadata" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "print_with_meta_data") }

      it "html publications with meta data" do
        expect(page).to have_css(".print-metadata", visible: false)

        within ".print-metadata" do
          expect(page).to have_text("© Crown copyright #{content_item['details']['public_timestamp'].to_date.year}")
          expect(page).to have_text("ISBN: #{content_item['details']['isbn']}")
        end
      end
    end

    describe "prime minister office organisation html publication" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "prime_ministers_office") }

      it "has the right organisation logo" do
        within(".organisation-logos__logo:nth-of-type(4)") do
          expect(page).to have_css(".gem-c-organisation-logo.brand--cabinet-office")
        end
      end

      it "shows no contents when headings are an empty list" do
        within ".gem-c-inverse-header" do
          expect(page).not_to have_text("Contents")
        end
      end
    end

    describe "html publication with rtl text direction" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "arabic_translation") }

      it "has the correct rtl class" do
        expect(page).to have_css("#wrapper.direction-rtl"), "has .direction-rtl class on #wrapper element"
      end
    end

    describe "historically political html publication" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "published_with_history_mode") }

      it "describes the relevant government" do
        within ".govuk-notification-banner__content" do
          puts page.html
          expect(page).to have_text("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
        end
      end
    end
  end
end



# require "test_helper"

# class HtmlPublicationTest < ActionDispatch::IntegrationTest


#   test "withdrawn html publication" do
#     content_item = GovukSchemas::Example.find("html_publication", example_name: "prime_ministers_office")
#     content_item["withdrawn_notice"] = {
#       'explanation': "This is out of date",
#       'withdrawn_at': "2014-08-09T11:39:05Z",
#     }

#     stub_content_store_has_item(content_item["links"]["parent"][0]["base_path"])
#     stub_content_store_has_item("/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration", content_item.to_json)
#     visit_with_cachebust "/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration"

#     assert page.has_css?(".gem-c-notice__title", text: "This policy paper was withdrawn on 9 August 2014")
#     assert page.has_css?(".gem-c-notice", text: "This is out of date")
#   end

#   test "if document has no parent document_type 'publication' is shown" do
#     content_item = GovukSchemas::Example.find("html_publication", example_name: "prime_ministers_office")
#     parent = content_item["links"]["parent"][0]
#     parent["document_type"] = nil
#     content_item["withdrawn_notice"] = {
#       'explanation': "This is out of date",
#       'withdrawn_at': "2014-08-09T11:39:05Z",
#     }
#     stub_content_store_has_item(parent["base_path"])
#     stub_content_store_has_item("/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration", content_item.to_json)
#     visit_with_cachebust "/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration"

#     assert page.has_css?(".gem-c-notice__title", text: "This publication was withdrawn on 9 August 2014")
#   end

#   test "does not render with the single page notification button" do
#     setup_and_visit_html_publication("published")
#     assert_not page.has_css?(".gem-c-single-page-notification-button")
#   end

#   test "HTML publication that only applies to a set of nations, with alternative urls" do
#     setup_and_visit_html_publication("national_applicability_alternative_url_html_publication")
#     assert_has_devolved_nations_component("Applies to England, Scotland and Wales", [
#       {
#         text: "Publication for Northern Ireland",
#         alternative_url: "http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for",
#       },
#     ])
#   end

#   test "adds the noindex meta tag to mobile paths" do
#     path = "/government/publications/govuk-app-terms-and-conditions/html-attachment"
#     overrides = { "base_path" => path }
#     setup_and_visit_html_publication("published", overrides)
#     assert page.has_css?('meta[name="robots"][content="noindex"]', visible: false)
#   end
# end
