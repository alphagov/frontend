# frozen_string_literal: true

RSpec.feature "Register as an organisation which gets funding directly from the EU" do
  scenario do
    when_i_choose_an_organisation_type
    then_i_see_the_choose_an_organisation_details_page
  end

  def when_i_choose_an_organisation_type
    visit organisation_type_path
    choose "Research"
    click_on "Next"
  end

  def then_i_see_the_choose_an_organisation_details_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.organisation_details.title"))
    end
  end
end
