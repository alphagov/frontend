class DevelopmentController < ApplicationController
  layout false

  def index
    @paths = YAML.load_file(Rails.root.join("config/govuk_examples.yml"))
  end
end
