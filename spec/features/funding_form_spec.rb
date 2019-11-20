# frozen_string_literal: true

RSpec.feature "Register as an organisation which gets funding directly from the EU" do
  scenario do
    when_i_fill_in_contact_information
    then_i_see_the_choose_an_organisation_type_page
    when_i_choose_an_organisation_type
    then_i_see_the_choose_an_organisation_details_page
    when_i_fill_in_organisation_details
    then_i_see_the_companies_house_number_page
    when_i_fill_in_companies_house_number
    then_i_see_the_grant_agreement_number_page
    when_i_fill_in_the_grant_agreement_number
    then_i_see_the_programme_funding_page
    when_i_choose_a_programme_funding
    then_i_see_the_project_details_page
    when_i_fill_in_project_details
    then_i_see_the_partners_page
    when_i_choose_partners_option
    then_i_see_the_summary_page
  end

  def when_i_fill_in_contact_information
    visit contact_information_path
    fill_in "full_name", with: "John Doe"
    fill_in "job_title", with: "Student"
    fill_in "email_address", with: "john.doe@domain.tld"
    fill_in "telephone_number", with: "+440755 555 555"
    click_on "Save and continue"
  end

  def then_i_see_the_choose_an_organisation_type_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.organisation_type.title"))
    end
  end

  def when_i_choose_an_organisation_type
    choose "Research"
    click_on "Save and continue"
  end

  def then_i_see_the_choose_an_organisation_details_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.organisation_details.title"))
    end
  end

  def when_i_fill_in_organisation_details
    fill_in "organisation_name", with: "Organisation name"
    fill_in "address_line_1", with: "Street name"
    fill_in "address_line_2", with: "Flat number"
    fill_in "address_town", with: "Town"
    fill_in "address_county", with: "County"
    fill_in "address_postcode", with: "W6812"
    click_on "Save and continue"
  end

  def then_i_see_the_companies_house_number_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.companies_house_or_charity_commission_number.title"))
    end
  end

  def when_i_fill_in_companies_house_number
    choose "Yes"
    fill_in "companies_house_or_charity_commission_number_other", with: "Companies House number"
    click_on "Save and continue"
  end

  def then_i_see_the_grant_agreement_number_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.grant_agreement_number.title"))
    end
  end

  def when_i_fill_in_the_grant_agreement_number
    choose "Yes"
    fill_in "grant_agreement_number_other", with: "Grant agreement number"
    click_on "Save and continue"
  end

  def then_i_see_the_programme_funding_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.programme_funding.title"))
    end
  end

  def when_i_choose_a_programme_funding
    choose "Erasmus+"
    click_on "Save and continue"
  end

  def then_i_see_the_project_details_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.project_details.title"))
    end
  end

  def when_i_fill_in_project_details
    fill_in "project_name", with: "Project name"
    fill_in "total_amount_awarded", with: "12000"
    fill_in "start_date_day", with: "08"
    fill_in "start_date_month", with: "09"
    fill_in "start_date_year", with: "2018"
    fill_in "end_date_day", with: "10"
    fill_in "end_date_month", with: "11"
    fill_in "end_date_year", with: "2019"
    click_on "Save and continue"
  end

  def then_i_see_the_partners_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.outside_uk_participants.title"))
    end
  end

  def when_i_choose_partners_option
    choose "No"
    click_on "Save and continue"
  end

  def then_i_see_the_summary_page
    within("h1") do
      expect(page).to have_content(I18n.t!("funding_form.check_your_answers.title"))
    end

    expect(page).to have_content("Full name John Doe")
    expect(page).to have_content("Job title Student")
    expect(page).to have_content("Email address john.doe@domain.tld")
    expect(page).to have_content("Telephone number +440755 555 555")
    expect(page).to have_content("Type Research")
    expect(page).to have_content("Organisation name Organisation name")
    expect(page).to have_content("Address Street name Flat number County W6812")
    expect(page).to have_content("Companies House or Charity Commission number Companies House number")
    expect(page).to have_content("Grant agreement number Grant agreement number")
    expect(page).to have_content("Programme Erasmus+")
    expect(page).to have_content("Project name Project name")
    expect(page).to have_content("Total amount awarded 12,000 euros")
    expect(page).to have_content("Start date 8 September 2018")
    expect(page).to have_content("End date 10 November 2019")
    expect(page).to have_content("Non UK partners No")
  end
end
