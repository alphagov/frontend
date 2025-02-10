RSpec::Matchers.define :have_devolved_nations_component do |text, nations = nil|
  match do |page|
    within(".gem-c-devolved-nations") do
      expect(page).to have_text(text)
      nations&.each do |nation|
        expect(page).to have_link(nation[:text], href: nation[:alternative_url])
      end
    end
  end
end
