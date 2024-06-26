module ButtonAsLinkHelpers
  RSpec::Matchers.define :have_button_as_link do |text, attrs = {}|
    match do |actual|
      actual.has_css?(process_button_attributes(attrs), text:)
    end
  end

  def process_button_attributes(attrs)
    match_assert = ""
    # match_assert = ".gem-c-button"
    # match_assert << ".gem-c-button--start" if attrs[:start]
    match_assert << "[rel='#{attrs[:rel]}']" if attrs[:rel]
    match_assert << "[href='#{attrs[:href]}']" if attrs[:href]

    if attrs[:data]
      attrs[:data].each do |key, value|
        match_assert << "[data-#{key}='#{value}']"
      end
    end

    match_assert
  end
end
