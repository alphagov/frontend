class ContentItemPresenter < PublicationPresenter

  def slug
    URI.parse(base_path).path.sub(%r{\A/}, "")
  end

  def base_path
    artefact['base_path']
  end
end
