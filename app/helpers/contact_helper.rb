module ContactHelper
  def format_postal_address(postal_address)
    separate_lines_with_br_tags postal_address
  end

  def format_email_address(email_address)
    mail_to email_address
  end

  def format_website_url(website_url)
    link_to website_url
  end

  def format_opening_hours(opening_hours)
    separate_lines_with_br_tags opening_hours
  end

  private
    def separate_lines_with_br_tags(text)
      safe_join text.lines, tag(:br, nil, true)
    end
end
