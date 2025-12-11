RSpec.describe "How Government Works" do
  context "when visiting /government/how-government-works" do
    let(:content_item) { GovukSchemas::Example.find(:how_government_works, example_name: "reshuffle-mode-off") }
    let(:base_path) { content_item["base_path"] }

    before { stub_content_store_has_item(base_path, content_item) }

    it "displays the title" do
      visit base_path

      expect(page).to have_title("How government works")
    end
  end
end

# test "includes the current prime minister" do
#   setup_and_visit_content_item("reshuffle-mode-off")

#   assert page.has_text?(@content_item.dig("links", "current_prime_minister", 0, "title"))
# end

# test "includes the count of ministers" do
#   setup_and_visit_content_item("reshuffle-mode-off")

#   assert page.has_selector?(".gem-c-big-number", text: /#{@content_item.dig('details', 'ministerial_role_counts', 'prime_minister')}.+Prime Minister/m)
#   assert page.has_selector?(".gem-c-big-number", text: /#{@content_item.dig('details', 'ministerial_role_counts', 'cabinet_ministers')}.+Cabinet ministers/m)
#   assert page.has_selector?(".gem-c-big-number", text: /#{@content_item.dig('details', 'ministerial_role_counts', 'other_ministers')}.+Other ministers/m)
#   assert page.has_selector?(".gem-c-big-number", text: /#{@content_item.dig('details', 'ministerial_role_counts', 'total_ministers')}.+Total ministers/m)
# end

# test "includes the count of departments" do
#   setup_and_visit_content_item("reshuffle-mode-off")

#   assert page.has_selector?(".gem-c-big-number", text: /#{@content_item.dig('details', 'department_counts', 'ministerial_departments')}.+Ministerial departments/m)
#   assert page.has_selector?(".gem-c-big-number", text: /#{@content_item.dig('details', 'department_counts', 'non_ministerial_departments')}.+Non-ministerial departments/m)
#   assert page.has_selector?(".gem-c-big-number", text: /#{@content_item.dig('details', 'department_counts', 'agencies_and_other_public_bodies')}.+Agencies and other public bodies/m)
# end

# test "does not include the count of ministers during a reshuffle" do
#   setup_and_visit_content_item("reshuffle-mode-on")

#   assert_not page.has_selector?(".gem-c-big-number", text: /Prime Minister/m)
#   assert_not page.has_selector?(".gem-c-big-number", text: /Cabinet ministers/m)
#   assert_not page.has_selector?(".gem-c-big-number", text: /Other ministers/m)
#   assert_not page.has_selector?(".gem-c-big-number", text: /Total ministers/m)
# end
