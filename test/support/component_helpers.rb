class ActiveSupport::TestCase
  def assert_breadcrumb_rendered(element = 'Home')
    within(shared_component_selector('breadcrumbs')) do
      assert page.has_content?(element), "Unable to find '#{element}' in the breadcrumbs: #{page.body} "
    end
  end
end
