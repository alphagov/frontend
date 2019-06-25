class PromotionPresenter
  def initialize(details)
    @details = details
  end

  def organ_donor?
    category == "organ_donor"
  end

  def mot_reminder?
    category == "mot_reminder"
  end

  def url
    @url ||= details.fetch("url")
  end

  def opt_in_url
    @opt_in_url ||= (details["opt_in_url"] || url)
  end

  def opt_out_url
    @opt_out_url ||= details["opt_out_url"]
  end

private

  attr_reader :details

  def category
    @category ||= details.fetch("category")
  end
end
