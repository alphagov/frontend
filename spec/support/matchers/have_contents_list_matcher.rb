RSpec::Matchers.define :have_contents_list do |contents = []|
  match do |page|
    expect(page).to have_selector(".gem-c-contents-list")

    contents.each do |heading|
      selector = ".gem-c-contents-list a[href=\"##{heading[:id]}\"]"
      text = heading.fetch(:text)
      expect(page).to have_selector(selector)
      expect(page).to have_selector(selector, text:)
    end
  end
end
