module SchemaOrgHelpers
  REGISTER_TO_VOTE_SCHEMA = {
    "@context" => "http://schema.org",
    "@type" => "FAQPage",
    "headline" => "Register to vote",
    "description" => "<p>Register to vote to get on the electoral register, or to change your details.</p> <p>You need to be on the electoral register to vote in elections or referendums.</p>\n",
    "publisher" => {
      "@type" => "Organization",
      "name" => "GOV.UK",
      "url" => "https://www.gov.uk",
      "logo" => {
        "@type" => "ImageObject",
        "url" => "/assets/frontend/govuk_publishing_components/govuk-logo-73b5a4056ffe9988d02c728b56fe9fe7f90bb822322a5f6183ccbb92a99b019a.png",
      },
    },
    "mainEntity" => [
      {
        "@type" => "Question",
        "name" => "Related content",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<a href=\"/register-to-vote?src=actions\">Register to vote</a> <a href=\"/how-to-vote?src=actions\">How to vote</a> <a href=\"/how-to-vote?src=actions#voting-by-proxy\">Ask someone to vote for you</a>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "Deadline for registering to vote in the 6 May 2021 elections",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>You can no longer register to vote in the elections on 6 May. You can still register for future elections.</p>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "Who can register",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>You must be aged 16 or over (or 14 or over in Scotland and Wales).</p> <p>You must also be one of the following:</p> <ul>\n <li>a British citizen</li>\n <li>an Irish or EU citizen living in the UK</li>\n <li>a Commonwealth citizen who has permission to enter or stay in the UK, or who does not need permission</li>\n <li>a citizen of another country living in Scotland or Wales who has permission to enter or stay in the UK, or who does not need permission</li>\n</ul> <p>Check which <a href=\"/elections-in-the-uk?src=schema\">elections you’re eligible to vote in</a>.</p>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "Register online",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>It usually takes about 5 minutes.</p> <p><a rel=\"external\" href=\"https://www.registertovote.service.gov.uk/register-to-vote/start?src=schema\">Start now</a></p> <h2>What you need to know</h2> <p>You’ll be asked for your National Insurance number (but you can still register if you do not have one).</p> <p>After you’ve registered, your name and address will appear on the electoral register.</p>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "Check if you’re already registered",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p><a href=\"/contact-electoral-registration-office?src=schema\">Contact your local Electoral Registration Office</a> to find out if you’re already registered to vote.</p>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "Update your registration",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>You can also use the <a rel=\"external\" href=\"https://www.registertovote.service.gov.uk/register-to-vote/start?src=schema\">‘Register to vote’ service</a> to:</p> <ul>\n <li>change your name, address or nationality</li>\n <li>get on or off the <a href=\"/electoral-register?src=schema\">open register</a></li>\n</ul> <p>To do this, you need to register again with your new details (even if you’re already registered to vote).</p>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "Registering with a paper form",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>You can <a href=\"/government/publications/register-to-vote-if-youre-living-in-the-uk?src=schema\">register using a paper form in England, Wales and Scotland</a>.</p> <p>You’ll need to print, fill out and <a href=\"/contact-electoral-registration-office?src=schema\">send the form to your local Electoral Registration Officer</a>.</p>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "If you live abroad",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>You can use this service to <a rel=\"external\" href=\"https://www.registertovote.service.gov.uk/register-to-vote/start?src=schema\">register to vote</a> (or to renew or update your registration) if you:</p> <ul>\n <li>are a British citizen</li>\n <li>were registered to vote within the last 15 years (or, in some cases, if you were too young to register when you were in the UK)</li>\n</ul> <p>You may need your passport details.</p>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "If you’re a public servant posted overseas",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>There’s a different service for public servants (and their spouses and civil partners) who are posted overseas as:</p> <ul>\n <li><a href=\"/register-to-vote-crown-servants-british-council-employees?src=schema\">Crown servants or British council employees</a></li>\n <li>members of the <a href=\"/register-to-vote-armed-forces?src=schema\">armed forces</a>\n</li> </ul>\n",
        },
      },
      {
        "@type" => "Question",
        "name" => "Get help registering",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => "<p>You can get help registering from your local <a href=\"/get-on-electoral-register?src=schema\">Electoral Registration Office</a>.</p>\n",
        },
      },
    ],
  }.freeze

  def when_voting_is_open
    Timecop.freeze(Time.zone.local(2021, 5, 6, 21, 59, 0))
    yield
    Timecop.return
  end

  def when_voting_is_closed
    Timecop.freeze(Time.zone.local(2021, 5, 6, 22, 0, 0))
    yield
    Timecop.return
  end

  def setup_register_to_vote
    register_to_vote = @payload.merge(base_path: "/register-to-vote")
    stub_content_store_has_item("/register-to-vote", register_to_vote)
  end

  def find_schemas
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schema_sections.map { |section| JSON.parse(section.text(:all)) }
  end

  def find_schema_of_type(schema_type)
    find_schemas.detect { |schema| schema["@type"] == schema_type }
  end
end
