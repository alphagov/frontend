class FundingForm::CheckAnswersController < ApplicationController
  def show; end

  def submit; end

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(10).upcase
    "#{timestamp}-#{random_id}"
  end
end
