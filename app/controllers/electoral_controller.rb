class ElectoralController < ApplicationController
  def show
    @content_item = {
      title: "Elections lookup",
    }
  end
end
