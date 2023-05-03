class ElectoralPresenter
  def initialize(response)
    @response = response || {}
  end

  EXPECTED_KEYS = %w[
    address_picker
    addresses
    dates
    electoral_services
    registration
    postcode_location
  ].freeze

  EXPECTED_KEYS.each do |key|
    define_method key do
      response[key.to_s]
    end
  end

  def electoral_service_name
    electoral_services["name"] if electoral_services.present?
  end

  def presented_electoral_service_address
    address_lines(electoral_services)
  end

  def presented_registration_address
    address_lines(registration)
  end

  def upcoming_elections

    fake_response["dates"].flat_map { |date| present_ballots(date) }
    # dates.flat_map { |date| present_ballots(date) } if dates.present?
  end

  def use_electoral_services_contact_details?
    electoral_services.present? && !duplicate_contact_details?
  end

  def use_registration_contact_details?
    registration.present?
  end

  def show_picker?
    (address_picker.present? && no_contact_details?)
  end

private

  attr_reader :response

  def address_lines(property)
    if property["address"].present?
      property["address"].split("\n")
    end
  end

  def duplicate_contact_details?
    if electoral_services["address"].present? && registration["address"].present?
      electoral_services["address"].gsub(/\s+/, "") == registration["address"].gsub(/\s+/, "")
    end
  end

  def present_ballots(date)
    if date["ballots"].present?
      date["ballots"].map { |b| "#{b['poll_open_date']} - #{b['ballot_title']}" } +
      date["ballots"].map { |b| "#{b['poll_open_date']} - #{b['ballot_title']}" } +
      date["ballots"].map { |b| "#{b['poll_open_date']} - #{b['ballot_title']}" }      
    end
  end

  def no_contact_details?
    registration.nil? && electoral_services.nil?
  end

  def fake_response 
    JSON.parse('{"dates":[{"date":"2017-05-04","polling_station":{"polling_station_known":true,"custom_finder":null,"report_problem_url":"http://wheredoivote.co.uk/report_problem/?source=testing&source_url=testing","station":{"id":"w06000015.QK","type":"Feature","geometry":{"type":"Point","coordinates":[-3.119229,51.510885]},"properties":{"postcode":"","address":"EarlswoodSocialClub,160-164GreenwayRoad,Rumney"}}},"advance_voting_station":null,"notifications":[{"title":"Someunexpectedeventishappening","type":"cancelled_election","detail":"Somemoredetails","url":"https://foo.bar/baz"}],"ballots":[{"ballot_paper_id":"local.cardiff.pontprennauold-st-mellons.2017-05-04","ballot_title":"CardifflocalelectionPontprennau/OldSt.Mellons","ballot_url":"https://developers.democracyclub.org.uk/api/v1/local.cardiff.pontprennauold-st-mellons.2017-05-04/","poll_open_date":"2017-05-04","elected_role":"LocalCouncillor","metadata":null,"cancelled":false,"replaced_by":null,"replaces":null,"election_id":"local.cardiff.2017-05-04","election_name":"Cardifflocalelection","post_name":"Pontprennau/OldSt.Mellons","candidates_verified":false,"voting_system":{"slug":"FPTP","name":"First-past-the-post","uses_party_lists":false},"seats_contested":1,"candidates":[{"list_position":null,"party":{"party_id":"party:90","party_name":"LiberalDemocrats"},"person":{"ynr_id":23417,"name":"DavidKeigwin","absolute_url":"https://whocanivotefor.co.uk/person/23417/david-keigwin","email":"dave@example.com","photo_url":null}},{"list_position":null,"party":{"party_id":"party:52","party_name":"ConservativeandUnionistParty"},"person":{"ynr_id":8071,"name":"JoelWilliams","absolute_url":"https://whocanivotefor.co.uk/person/8071/joel-williams","email":null,"photo_url":"https://static-candidates.democracyclub.org.uk/media/images/images/8071.png"}}],"wcivf_url":"https://whocanivotefor.co.uk/elections/local.cardiff.2017-05-04/post-UTE:W05000900/pontprennauold-st-mellons"}]}]}')
  end
end
