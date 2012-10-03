class RedirectWardenFactory


  # Will return a lambda for the passed publication to check.
  # The lambda will be check, if a given link is present in the publication.
  #
  # Example
  #
  #   warden_factory.for(publication).call('http://example.com')
  #   # => true if 'http://example.com' is present in the publication
  # 
  def for(publication)
    return nil unless publication

    case publication.type
      when 'answer'
        answer_warden(publication)
      when 'guide'
        guide_warden(publication)
      when 'programme'
        programme_warden(publication)
      when 'transaction'
        transaction_warden(publication)
      else
        nil
    end
  end

  private
  def answer_warden(publication)
    lambda do |link|
      link_in_markup?(publication.body, link)
    end
  end

  def guide_warden(publication)
    lambda do |link|
      publication.video_url == link or link_in_parts_body?(publication, link)
    end
  end

  def programme_warden(publication)
    lambda do |link|
      link_in_parts_body?(publication, link)
    end
  end

  def transaction_warden(publication)
    lambda do |link|
      publication.link == link or
          link_in_markup?(publication.more_information, link) or
          link_in_markup?(publication.minutes_to_complete, link) or
          link_in_markup?(publication.alternate_methods, link)
    end
  end

  def link_in_markup?(content, link)
    content && content.include?("](#{link}")
  end

  def link_in_parts_body?(publication, link)
    publication.parts.any?{|part| link_in_markup?(part.body || '', link)}
  end

end