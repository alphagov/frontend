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
  end
end

# class ServiceManualServiceToolkitTest < ActionDispatch::IntegrationTest

#   test "the service toolkit does not include the new style feedback form" do
#     setup_and_visit_content_item("service_manual_service_toolkit")

#     assert_not page.has_css?(".improve-this-page"),
#                "Improve this page component should not be present on the page"
#   end

#   test "the service toolkit displays the introductory hero" do
#     setup_and_visit_content_item("service_manual_service_toolkit")

#     assert page.has_content? <<~TEXT.chomp
#       Design and build government services
#       All you need to design, build and run services that meet government standards.
#     TEXT
#   end

#   test "the homepage includes both collections" do
#     setup_and_visit_content_item("service_manual_service_toolkit")

#     assert_equal 2, collections.length, "Expected to find 2 collections"
#   end

#   test "the homepage includes the titles for both collections" do
#     setup_and_visit_content_item("service_manual_service_toolkit")

#     within(the_first_collection) do
#       assert page.has_content? "Standards"
#     end

#     within(the_second_collection) do
#       assert page.has_content? "Buying"
#     end
#   end

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
