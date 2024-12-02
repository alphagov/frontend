module BlockHelper
  def render_block(block, options: {})
    render("landing_page/blocks/#{block.type}", block:, options:)
  rescue ActionView::MissingTemplate
    Rails.logger.warn("Missing template for block #{block.type}")
    ""
  end
end
