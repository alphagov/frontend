class HeroPresenter
  def initialize
    path = File.join(Rails.root, "config", "heroes.yml")
    if File.exist?(path)
      @heroes = YAML.load_file(path)
    end
  end

  def random_hero
    random = @heroes[rand(@heroes.length)]
    {
      text: format_text(random["text"]),
      name: random["subject"]
    }
  end

  def format_text(hero)
    text = hero.strip.gsub(/\n/, "</p><p class=\"govuk-body\">")
    "<p class=\"govuk-body\">#{text}</p>"
  end
end
