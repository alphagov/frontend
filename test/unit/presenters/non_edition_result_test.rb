require_relative "../../test_helper"

class NonEditionResultTest < ActiveSupport::TestCase
  should "return document_type as the format" do
    result = NonEditionResult.new(
      SearchParameters.new({}),
      {
        "document_type" => "manual_section",
      },
    )

    assert_equal "manual_section", result.format
  end

  should "include a humanized document_type in metadata" do
    result = NonEditionResult.new(
      SearchParameters.new({}),
      {
        "document_type" => "manual_section",
      },
    )

    assert result.metadata.include?("Manual section")
  end

  should "use a custom humanized document_type form for special cases" do
    result = NonEditionResult.new(
      SearchParameters.new({}),
      {
        "document_type" => "cma_case",
      },
    )

    assert result.metadata.include?("CMA case")
  end

  should "include public_timestamp date in metadata" do
    result = NonEditionResult.new(
      SearchParameters.new({}),
      {
        "document_type" => "cma_case",
        "public_timestamp" => "2014-12-23T12:34:56",
      },
    )

    assert result.metadata.include?("23 December 2014")
  end

  should "fall back to last_update if public_timestamp is blank" do
    result = NonEditionResult.new(
      SearchParameters.new({}),
      {
        "document_type" => "cma_case",
        "last_update" => "2014-11-17T12:34:56",
      },
    )

    assert result.metadata.include?("17 November 2014")
  end

  should "prefer public_timestamp over last_update" do
    result = NonEditionResult.new(
      SearchParameters.new({}),
      {
        "document_type" => "cma_case",
        "public_timestamp" => "2014-12-23T12:34:56",
        "last_update" => "2014-11-17T12:34:56",
      },
    )

    assert result.metadata.include?("23 December 2014")
  end

  should "include organisations in metadata" do
    result = NonEditionResult.new(
      SearchParameters.new({}),
      {
        "document_type" => "manual",
        "organisations" => [
          {
            "slug" => "home-office",
            "title" => "Home Office",
          },
          {
            "slug" => "uk-visas-and-immigration",
            "title" => "UK Visas and Immigration",
            "acronym" => "UKVI",
          },
        ],
      },
    )

    assert result.metadata.include?(
      "Home Office, <abbr title='UK Visas and Immigration'>UKVI</abbr>"
    )
  end
end
