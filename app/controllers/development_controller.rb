class DevelopmentController < ApplicationController
  layout false

  def index
    @schema_names = %w[
      calendar
      completed_transaction
      homepage
      local_transaction
      place
      simple_smart_answer
      transaction
      travel_advice
    ]

    @paths = YAML.load_file(Rails.root.join("config/govuk_examples.yml"))
  end
end
