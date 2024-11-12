RSpec.describe "RecruitmentBanner" do
  include RecruitmentBannerHelper

  it "displays UKVI banner on contact page" do
    content_store_has_random_item(base_path: "/contact-ukvi-inside-outside-uk", schema: "simple_smart_answer")

    visit "/contact-ukvi-inside-outside-uk"

    expect(page).to have_http_status(200)
    expect(page).to have_selector(".gem-c-intervention")
  end

  it "doesn't display UKVI banner on other pages" do
    content_store_has_random_item(base_path: "/the-bridge-of-death", schema: "simple_smart_answer")

    visit "/the-bridge-of-death"

    expect(page).to have_http_status(200)
    expect(page).to_not have_selector(".gem-c-intervention")
  end
end
