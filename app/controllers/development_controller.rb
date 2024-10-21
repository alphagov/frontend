class DevelopmentController < ApplicationController
  layout false

  def index
    @paths = YAML.load_file(Rails.root.join("config/govuk_examples.yml"))
  end

private

  def content_item
    @content_item ||= ContentItemFactory.build_hardcoded
  end
end
