class RedirectWardenFactory


  def for publication
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
      publication.link == link or link_in_markup?(publication.more_information, link)
    end
  end

  def link_in_markup?(content, link)
    content.include?("](#{link}")
  end

  def link_in_parts_body?(publication, link)
    publication.parts.any?{|part| link_in_markup?(part.body || '', link)}
  end

end