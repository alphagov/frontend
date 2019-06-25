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

private

  attr_reader :details

  def category
    @category ||= details.fetch("category")
  end
end
