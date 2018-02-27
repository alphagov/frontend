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
end
