class QaPagePresenter
  attr_reader :content_item, :image_placeholder_urls, :logo_url

  def initialize(content_item, logo_url, image_placeholder_urls)
    @content_item = content_item
    @logo_url = logo_url
    @image_placeholder_urls = image_placeholder_urls
  end

  def structured_data
    return {} unless QaPagePresenter.brexit_checker?(content_item)

    {
      "@context": "http://schema.org",
      "@type": "QAPage",
      "primaryImageOfPage": govuk_image,
      "headline": content_item['title'],
      "datePublished": first_published_at,
      "dateModified": content_item['public_updated_at'],
      "description": content_item['description'],
      "image": image_placeholder_urls,
      "author": gds_organisation,
      "publisher": govuk_organisation,
      "mainEntity": question_and_answer,
    }
  end

  def self.brexit_checker?(content_item)
    content_item['content_id'] == BREXIT_CHECKER_CONTENT_ID
  end

private

  BREXIT_CHECKER_CONTENT_ID = "58d093a1-787d-4f36-a568-86da23a7b884".freeze

  def first_published_at
    content_item['first_published_at']
  end

  def govuk_image
    @govuk_image ||= {
      "@type": "ImageObject",
      "name": logo_url
    }
  end

  def govuk_organisation
    {
      "@type": "Organization",
      "name": "GOV.UK",
      "url": "https://www.gov.uk",
      "logo": govuk_image
    }
  end

  def gds_organisation
    {
      "@type": "Organization",
      "name": "Government Digital Service",
      "url": "https://www.gov.uk/government/organisations/government-digital-service",
      "logo": govuk_image
    }
  end

  def question_and_answer
    {
      "@type": "Question",
      "author": gds_organisation,
      "image": govuk_image,
      "name": content_item['title'],
      "text": I18n.t("qa_pages.checker.question"),
      "url": page_url,
      "dateCreated": first_published_at,
      "answerCount": 1,
      "acceptedAnswer": {
        "@type": "Answer",
        "author": gds_organisation,
        "url": page_url,
        "dateCreated": first_published_at,
        "text": I18n.t("qa_pages.checker.answer")
      }
    }
  end

  def page_url
    URI.join(Plek.new.website_root, content_item['base_path'])
  end

  def image_url(image_path)
    ActionController::Base.helpers.image_url(image_path)
  end
end
