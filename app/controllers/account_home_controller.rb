class AccountHomeController < ApplicationController
  include GovukPersonalisation::ControllerConcern

  def show
    redirect_with_analytics GovukPersonalisation::Urls.your_account
  end
end
