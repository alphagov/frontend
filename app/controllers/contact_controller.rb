class ContactController < ApplicationController
  include ApplicationHelper

  after_action :add_cors_header

  def index
    @popular_links = filtered_links(I18n.t("contact.popular"))
    @long_tail_links = filtered_links(I18n.t("contact.long_tail"))
    @breadcrumbs = [breadcrumbs.first]
  end

  def new
    @breadcrumbs = breadcrumbs

    respond_to do |format|
      format.html do
        render :new
      end
      format.any do
        head(:not_acceptable)
      end
    end
  end

  def create
    data = contact_params.merge(browser_attributes)
    ticket = ticket_class.new data

    if ticket.valid?
      GovukStatsd.increment("#{type}.successful_submission")
      @contact_provided = data[:email].present?

      respond_to_valid_submission(ticket)
    else
      GovukStatsd.increment("#{type}.invalid_submission")
      raise SpamError if ticket.spam?

      @errors = ticket.errors.to_hash
      @old = data

      respond_to_invalid_submission(ticket)
    end
  end

private

  def respond_to_valid_submission(ticket)
    # rubocop:disable Rails/SaveBang
    ticket.save
    # rubocop:enable Rails/SaveBang
    confirm_submission
  end

  def confirm_submission
    respond_to do |format|
      format.html do
        hide_report_a_problem_form_in_response
        if @contact_provided
          redirect_to contact_named_contact_thankyou_path
        else
          redirect_to contact_anonymous_feedback_thankyou_path
        end
      end
      format.any { head(:not_acceptable) }
    end
  end

  def respond_to_invalid_submission(_ticket)
    rerender_form
  end

  def rerender_form
    respond_to do |format|
      format.html do
        render :new
      end
    end
  end

  def browser_attributes
    technical_attributes.merge(referrer_attribute)
  end

  def referrer_attribute
    referrer = contact_params[:referrer] || params[:referrer] || request.referer
    referrer = referrer.gsub(/[^\s=\/?&]+(?:@|%40)[^\s=\/?&]+/, "[email]") if referrer.present? && referrer.length < 1000
    referrer.present? ? { referrer: } : {}
  end

  def technical_attributes
    { user_agent: request.user_agent }
  end

  def add_cors_header
    origin_header = request.headers["origin"]
    if origin_header && origin_header.end_with?(".gov.uk")
      response.headers["Access-Control-Allow-Origin"] = origin_header
    end
  end

  def contact_params
    params[type] || {}
  end

  def external_link?(url)
    URI(url).host && URI(url).host != "www.gov.uk"
  end

  def filtered_links(array)
    array.map do |item|
      {
        link: {
          text: item[:title],
          path: item[:url],
          description: item[:description],
          full_size_description: true,
          rel: external_link?(item[:url]) ? "external" : "",
        },
      }
    end
  end

  def breadcrumbs
    [
      {
        title: "Home",
        url: "/",
      },
      {
        title: "Contact",
        url: "/contact",
      },
    ]
  end
end
