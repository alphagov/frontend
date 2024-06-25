module ComponentHelpers
  def component_name
    raise NotImplementedError, "Override this method in your test class"
  end

  def render_component(locals, &block)
    if block_given?
      render("components/#{component_name}", locals, &block)
    else
      render "components/#{component_name}", locals
    end
  end
end
