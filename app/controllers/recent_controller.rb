class RecentController < ApplicationController
  def index
    @results = Recent.new.feed_items
  end
end
