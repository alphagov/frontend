class Missions < FlexiblePage
  def initialize(content_store_response)
    super

    add_section(Breadcrumbs.new(breadcrumbs:))

    add_section(Involved.new(organisations: linked("organisations").select { |org| org.title == "Prime Minister's Office, 10 Downing Street" }))

    add_section(ImpactHeader.new(
                  description:,
                  image: first_hero["image"].deep_symbolize_keys,
                  title:,
                  variant: :govuk,
                ))
  end

  def breadcrumbs
    @breadcrumbs ||= content_store_response.dig("details", "breadcrumbs")&.map { { title: it["title"], url: it["href"] } }
  end

  def first_hero
    @first_hero ||= content_store_response.dig("details", "blocks").find { |block| block["type"] == "hero" }
  end

  # def impact_description
  #   subheading = first_hero["hero_content"]["blocks"].find { |block| block["type"] == "heading" && block["heading_level"] == 2 }["content"]
  #   content = first_hero["hero_content"]["blocks"].find { |block| block["type"] == "govspeak" }["content"]
  #   "<h2>#{subheading}</h2>#{content}".html_safe
  # end
end
