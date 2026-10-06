class RecentController < ApplicationController
  def index
    results = Recent.new.feed_items
    @presented_results = RecentPresenter.new(results).formatted_results
  end
end
