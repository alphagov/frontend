class ContactTicket < Ticket
  attr_accessor :location,
                :textdetails,
                :name,
                :email

  attr_writer :javascript_enabled, :referrer, :link

  validate :validate_link
  validates :link, length: { maximum: FIELD_MAXIMUM_CHARACTER_COUNT, message: "The page field can be max #{FIELD_MAXIMUM_CHARACTER_COUNT} characters" }
  validates :textdetails, presence: { message: "The message field cannot be empty" }
  validates :textdetails, length: { maximum: FIELD_MAXIMUM_CHARACTER_COUNT, message: "The message field can be max #{FIELD_MAXIMUM_CHARACTER_COUNT} characters" }
  validates :name, length: { maximum: FIELD_MAXIMUM_CHARACTER_COUNT, message: "The name field can be max #{FIELD_MAXIMUM_CHARACTER_COUNT} characters" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "The email address must be valid" }, allow_blank: true
  validates :email, length: { maximum: FIELD_MAXIMUM_CHARACTER_COUNT, message: "The email field can be max #{FIELD_MAXIMUM_CHARACTER_COUNT} characters" }
  validate :validate_mail_name_connection
  validates :location, presence: { message: "Please tell us what your contact is to do with" }

  def javascript_enabled
    @javascript_enabled.present?
  end

  def link
    @link.presence
  end

  def save
    if valid? && !bad_email_address?
      if anonymous?
        Rails.application.config.support_api.create_anonymous_long_form_contact(ticket_details)
      else
        SupportTicketCreator.call(**ticket_details)
      end
    end
  end

private

  def ticket_details
    details = {
      details: textdetails,
      link:, # needed for 'named contact' requests
      user_specified_url: link, # needed for the `support-api` app
      user_agent:,
      referrer:,
      javascript_enabled:,
      url:,
      path: url ? URI(url).path : nil, # needed for the `support-api` app
    }
    details[:requester] = { name:, email: } unless anonymous?
    details
  end

  def anonymous?
    name.blank? && email.blank?
  end

  def referrer
    referring_url_within_govuk? ? @referrer : nil
  end

  def validate_mail_name_connection
    if name.blank? && email.present?
      @errors.add :name, "The name field cannot be empty"
    end
    if email.blank? && name.present?
      @errors.add :email, "The email field cannot be empty"
    end
  end

  def bad_email_address?
    bad_domains = Regexp.union(
      /\A*@.*\.beameagle.top$/,
      /\A*@.*\.bishop-knot.xyz$/,
      /\A*@.*\.captainmaid.top$/,
      /\A*@.*\.eaglefight.top$/,
      /\A*@.*\.gull-minnow.top$/,
      /\A*@.*\.hensailor.xyz$/,
      /\A*@.*\.lady-and-lunch.xyz$/,
      /\A*@.*\.marver-coats.xyz$/,
      /\A*@.*\.pine-and-onyx.xyz$/,
      /\A*@.*\.stars-and-glory.top$/,
      /\A*@.*\.veinflower.xyz$/,
      /\A*@qq.com$/,
    )

    bad_domains.match?(email)
  end

  def validate_link
    if (location == "specific") && link.blank?
      @errors.add :link, "The link field cannot be empty"
    end
  end

  def referring_url_within_govuk?
    @referrer && @referrer.starts_with?(Plek.new.website_root)
  end
end
