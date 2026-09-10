RSpec.describe "Forcing an Asset Manager handshake on the draft stack" do
  around do |example|
    original_hostname_prefix = ENV["PLEK_HOSTNAME_PREFIX"]
    original_govuk_environment = ENV["GOVUK_ENVIRONMENT"]
    example.run
    ENV["PLEK_HOSTNAME_PREFIX"] = original_hostname_prefix
    ENV["GOVUK_ENVIRONMENT"] = original_govuk_environment
  end

  context "when on a live (non-draft) host" do
    before do
      ENV["PLEK_HOSTNAME_PREFIX"] = nil
      content_store_has_random_item(base_path: "/help", schema: "help_page")
    end

    it "does not add a placeholder asset script tag" do
      get "/help"

      expect(response.body).not_to include("draft-assets")
    end
  end

  context "when on a draft host" do
    before do
      ENV["PLEK_HOSTNAME_PREFIX"] = "draft-"
      content_store_has_random_item(base_path: "/help", schema: "help_page")
    end

    it "adds a parser-blocking script tag that loads the placeholder asset from draft-assets with the CSP nonce" do
      ENV["GOVUK_ENVIRONMENT"] = "production"

      get "/help"

      # This must remain a classic, parser-blocking script. The nonce is
      # required to satisfy the page's CSP because draft-assets is not an
      # allowed script-src host.
      #
      # async/defer/type="module" would all make the browser carry on
      # parsing instead of blocking on the request. This workaround relies
      # on the Asset Manager auth handshake completing before the browser
      # parses the rest of the page (and therefore before any draft <img>
      # tags further down get a chance to start their own handshakes).
      expect(response.body).to include(
        '<script nonce="',
      )
      expect(response.body).to include(
        'src="https://draft-assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg"></script>',
      )
    end

    it "places the script tag before the closing </head>, so it blocks parsing early" do
      ENV["GOVUK_ENVIRONMENT"] = "production"

      get "/help"

      script_index = response.body.index("draft-assets")
      head_close_index = response.body.index("</head>")

      expect(script_index).to be_present
      expect(script_index).to be < head_close_index
    end

    describe "which draft-assets host is used, per GOVUK_ENVIRONMENT" do
      {
        "staging" => "staging.publishing.service.gov.uk",
        "integration" => "integration.publishing.service.gov.uk",
        "production" => "publishing.service.gov.uk",
        "local" => "publishing.service.gov.uk",
        "some-unrecognised-value" => "publishing.service.gov.uk",
      }.each do |govuk_environment, expected_host|
        context "when GOVUK_ENVIRONMENT is #{govuk_environment.inspect}" do
          before { ENV["GOVUK_ENVIRONMENT"] = govuk_environment }

          it "points the script at draft-assets.#{expected_host}" do
            get "/help"

            expect(response.body).to include(
              %(<script nonce="),
            )
            expect(response.body).to include(
              %(src="https://draft-assets.#{expected_host}/media/5e59279b86650c53b2cefbfe/placeholder.jpg"></script>),
            )
          end
        end
      end

      context "when GOVUK_ENVIRONMENT is not set at all" do
        before do
          ENV.delete("GOVUK_ENVIRONMENT")
          content_store_has_random_item(base_path: "/help", schema: "help_page")
        end

        it "falls back to the production draft-assets host" do
          get "/help"

          expect(response.body).to include(
            '<script nonce="',
          )
          expect(response.body).to include(
            'src="https://draft-assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg"></script>',
          )
        end
      end
    end
  end
end
