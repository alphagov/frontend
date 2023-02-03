class LicenceTransactionPresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %w[
    licence_transaction_continuation_link
    licence_transaction_licence_identifier
    licence_transaction_will_continue_on
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details["metadata"][key] if details["metadata"]
    end
  end

  def body
    details["body"]
  end

  def slug
    URI.parse(base_path).path.split("/").last
  end
end
