class ContactController < ApplicationController
  include ApplicationHelper

  def index
    @popular_links = filtered_links(I18n.t("contact.popular"))
    @long_tail_links = filtered_links(I18n.t("contact.long_tail"))
    @breadcrumbs = [breadcrumbs.first]
  end

private

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
