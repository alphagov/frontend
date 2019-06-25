class CompletedTransactionPresenter < ContentItemPresenter
  def promotion
    PromotionPresenter.new(details["promotion"]) if details && details["promotion"]
  end

  def web_url
    Plek.new.website_root + base_path
  end
end
