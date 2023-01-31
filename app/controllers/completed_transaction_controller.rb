class CompletedTransactionController < ContentItemsController
  include Cacheable
  # These 2 legacy completed transactions are linked to from multiple
  # transactions. The user satisfaction survey should not be shown for these as
  # it would generate noisy data for the linked organisation.
  LEGACY_SLUGS = [
    "done/transaction-finished",
    "done/driving-transaction-finished",
  ].freeze

  # The Photo ID promo should only appear on these pages. This has been
  # hardcoded as it is a short campaign and will be removed manually when
  # the campaign has ended.
  PHOTO_ID_PROMO_SLUGS = %w[
    done/find-pension-contact-details
    done/lost-stolen-passport
    done/use-lasting-power-of-attorney
    done/vehicle-operator-licensing
    done/apply-first-provisional-driving-licence
    done/apply-blue-badge
    done/get-state-pension
    done/check-driving-licence
    done/blue-badge
    done/renew-medical-driving-licence
    done/apply-driver-digital-tachograph-card
    done/prove-right-to-work
    done/report-driving-medical-condition
    done/brp-not-arrived
    done/send-prisoner-money
    done/brp-report-lost-stolen
    done/brp-collection-problem
    done/view-prove-your-rights-uk
    done/brp-report-problem
    done/find-driving-schools-and-lessons
    done/register-to-vot
  ].freeze

  def show; end

private

  helper_method :show_survey?, :promotion

  # This can be removed when the Photo ID promo is removed,
  # the partial call can be replaced with "publication.promotion"
  def promotion
    publication.promotion || photo_id_promotion
  end

  def publication_class
    CompletedTransactionPresenter
  end

  def show_survey?
    LEGACY_SLUGS.exclude?(params[:slug])
  end

  # To copy the same structure that a promo would appear in the
  # content item, means we don't need to modify any other code.
  def photo_id_promotion
    { 'category': "photo_id", 'url': "/how-to-vote/photo-id-youll-need" }.with_indifferent_access if PHOTO_ID_PROMO_SLUGS.include?(params[:slug])
  end
end
