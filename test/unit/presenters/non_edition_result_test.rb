require "test_helper"

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
