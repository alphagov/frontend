class ActiveSupport::TestCase
  def assert_has_component_title(title, context = nil)
    within shared_component_selector("title") do
      component_data = JSON.parse(page.text)
      assert_equal title, component_data.fetch("title")
      assert_equal context, component_data.fetch("context") if context
    end
  end

  def assert_has_button(text)
    assert page.has_css?("button", text: text)
  end

  def assert_has_button_as_link(text, attrs = {})
    assert page.has_css?(process_button_attributes(attrs), text: text)
  end

  def refute_has_button_component(text, attrs = {})
    assert page.has_no_css?(process_button_attributes(attrs), text: text)
  end

  def process_button_attributes(attrs)
    match_assert = ".gem-c-button"
    match_assert << ".gem-c-button--start" if attrs[:start]
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
