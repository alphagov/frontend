module PublicationHelper
  def fetch_publication(params)
    options = {
        edition: params[:edition],
        snac: params[:snac]
    }.reject { |k, v| v.blank? }
    publisher_api.publication_for_slug(params[:slug], options)
  rescue ArgumentError
    logger.error "invalid UTF-8 byte sequence with slug `#{params[:slug]}`"
    return false
  rescue URI::InvalidURIError
    logger.error "Invalid URI formed with slug `#{params[:slug]}`"
    return false
  end
end