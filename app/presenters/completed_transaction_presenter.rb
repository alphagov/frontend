class CompletedTransactionPresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = [
    :promotion,
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end

  def web_url
    Plek.new.website_root + base_path
  end
end
