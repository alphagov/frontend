class AccountHomeController < ApplicationController
  include GovukPersonalisation::ControllerConcern

  def show
    redirect_with_analytics GovukPersonalisation::Urls.one_login_your_services
  end
end
