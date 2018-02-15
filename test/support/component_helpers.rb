class ActiveSupport::TestCase
  def assert_breadcrumb_rendered(element = 'Home')
    within(shared_component_selector('breadcrumbs')) do
      assert page.has_content?(element), "Unable to find '#{element}' in the breadcrumbs: #{page.body} "
    end
  end

  def assert_has_component_title(title, context = nil)
    within shared_component_selector("title") do
      component_data = JSON.parse(page.text)
      assert_equal title, component_data.fetch("title")
      assert_equal context, component_data.fetch("context") if context
    end
  end

  def assert_has_button_component(text, attrs = {})
    all(shared_component_selector('button')).each do |button|
      data = JSON.parse(button.text).symbolize_keys
      next unless text == data.delete(:text)
      data.delete(:extra_attrs) if data[:extra_attrs].blank?
      return assert_equal attrs, data
    end

    fail_button_not_found(text)
  end

  def click_button_component(text)
    selector = shared_component_selector("button")

    all(selector).each do |button|
      data = JSON.parse(button.text).symbolize_keys

      next if data[:text] != text

      if data.has_key?(:href)
        return visit(data[:href])
      else
        form = find(selector).first(:xpath, "ancestor::form")
        return Capybara::RackTest::Form.new(page.driver, form.native).submit({})
      end
    end

    fail_button_not_found(text)
  end

  def fail_button_not_found(button_text)
    fail "Button component not found with text '#{button_text}'"
  end
end
