RSpec.describe "Service Toolkit page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("service_manual_service_toolkit", example_name: "service_manual_service_toolkit") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the page" do
      expect(page.status_code).to eq(200)
    end

    it "has the correct title" do
      expect(page.title).to eq("Service Toolkit - GOV.UK")
    end

    it "has the correct heading and description" do
      within("h1") do
        expect(page).to have_text("Design and build government services")
      end

      within(".gem-c-lead-paragraph") do
        expect(page).to have_text("All you need to design, build and run services that meet government standards.")
      end
    end

    it "has two collections of links" do
      expect(content_store_response["details"]["collections"].size).to eq 2
    end

    it "has the correct level 2 headings" do
      within(".service-toolkit:nth-of-type(1) h2") do
        expect(page).to have_text "Standards"
      end

      within(".service-toolkit:nth-of-type(2) h2") do
        expect(page).to have_text "Buying"
      end
    end
  end
end

# class ServiceManualServiceToolkitTest < ActionDispatch::IntegrationTest

#   test "the homepage includes the descriptions for both collections" do
#     setup_and_visit_content_item("service_manual_service_toolkit")

#     within(the_first_collection) do
#       assert page.has_content? "Meet the standards for government services"
#     end

#     within(the_second_collection) do
#       assert page.has_content? "Extra skills, people and technology to help build your service"
#     end
#   end

#   test "the homepage includes the links from all collections" do
#     setup_and_visit_content_item(
#       "service_manual_service_toolkit",
#       "details" => {
#         "collections" => [
#           {
#             "title" => "Standards",
#             "description" => "Meet the standards for government services",
#             "links" => [
#               {
#                 "title" => "Service Standard",
#                 "url" => "https://www.gov.uk/service-manual/service-standard",
#                 "description" => "",
#               },
#             ],
#           },
#           {
#             "title" => "Buying",
#             "description" => "Skills and technology for building digital services",
#             "links" => [
#               {
#                 "title" => "Digital Marketplace",
#                 "url" => "https://www.gov.uk/digital-marketplace",
#                 "description" => "",
#               },
#             ],
#           },
#         ],
#       },
#     )

#     within(the_first_collection) do
#       assert page.has_link? "Service Standard",
#                             href: "https://www.gov.uk/service-manual/service-standard"
#     end

#     within(the_second_collection) do
#       assert page.has_link? "Digital Marketplace",
#                             href: "https://www.gov.uk/digital-marketplace"
#     end
#   end

# private

#   def collections
#     find_all(".app-collection")
#   end

#   def the_first_collection
#     collections[0]
#   end

#   def the_second_collection
#     collections[1]
#   end
# end
