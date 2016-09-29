class TravelAdviceController < ApplicationController
  def index
    set_expiry

    begin
      response = content_store.content_item("/foreign-travel-advice")
    rescue GdsApi::HTTPNotFound
      return error_404
    rescue GdsApi::HTTPGone
      return error_410
    end

    content_item = response.to_hash
    merge_hardcoded_breadcrumbs!(content_item)

    @presenter = TravelAdviceIndexPresenter.new(content_item)
    set_slimmer_artefact_headers(content_item, format: "travel-advice")

    respond_to do |format|
      format.html { render locals: { full_width: true } }
      format.atom { set_expiry(5.minutes) }
      # TODO: Doing a static redirect to the API URL here means that an API call
      #       and a variety of other logic will have been executed unnecessarily.
      #       We should move this to the top of the method or out to routes.rb for
      #       efficiency.
      format.json { redirect_to "/api/foreign-travel-advice.json" }
    end
  end

private

  # This will soon be replaced by:
  #
  # https://trello.com/c/tomHUlp7/475-define-data-format-for-breadcrumbs
  # https://trello.com/c/vm54jvVo/477-send-hard-coded-breadcrumbs-to-publishing-api
  def merge_hardcoded_breadcrumbs!(content_item)
    content_item.merge!(
      "tags" => [{
          "title" => "Travel abroad",
          "web_url" => "/browse/abroad/travel-abroad",
          "details" => { "type" => "section" },
          "content_with_tag" => { "web_url" => "/browse/abroad/travel-abroad" },
          "parent" => {
            "web_url" => "/browse/abroad",
            "title" => "Passports, travel and living abroad",
            "details" => { "type" => "section" },
            "content_with_tag" => { "web_url" => "/browse/abroad" },
            "parent" => nil,
          },
      }]
    )
  end
end
