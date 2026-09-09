RSpec.describe Person do
  subject(:person) { described_class.new(content_store_response) }

  let(:content_store_response) do
    {
      "base_path" => "/government/people/rufus-scrimgeour",
      "locale" => "en",
      "details" => {
        "image" => { "url" => "https://assets.publishing.service.gov.uk/rufus.jpg" },
      },
      "links" => {
        "role_appointments" => [
          role_appointment(
            title: "Minister for Magic",
            current: true,
            order: 2,
            base_path: "/government/ministers/minister-for-magic",
            document_type: "ministerial_role",
          ),
          role_appointment(
            title: "Head of the Auror Office",
            current: true,
            order: 1,
            base_path: "/government/ministers/head-of-the-auror-office",
            document_type: "role",
          ),
          role_appointment(
            title: "Director of Magical Security",
            current: false,
            order: 3,
            started_on: "2014-06-01T00:00:00+00:00",
            ended_on: "2016-07-31T00:00:00+00:00",
            base_path: "/government/ministers/director-of-magical-security",
            document_type: "role",
          ),
          role_appointment(
            title: "Junior Minister",
            current: false,
            order: 4,
            started_on: "2012-01-01T00:00:00+00:00",
            ended_on: "2014-05-31T00:00:00+00:00",
            base_path: "/government/ministers/junior-minister",
            document_type: "ministerial_role",
          ),
        ],
      },
    }
  end

  describe "#current_roles" do
    it "returns only current roles in appointment order" do
      expect(person.current_roles.map(&:title)).to eq([
        "Head of the Auror Office",
        "Minister for Magic",
      ])
    end

    it "models role content used by the view" do
      role = person.current_roles.first

      expect(role.base_path).to eq("/government/ministers/head-of-the-auror-office")
      expect(role.document_type).to eq("role")
      expect(role.body).to eq("<p>Protects the magical community.</p>")
      expect(role.parent_organisations.map(&:title)).to eq(["Ministry of Magic"])
    end
  end

  describe "#currently_in_a_role?" do
    it "is true when there is a current appointment" do
      expect(person).to be_currently_in_a_role
    end

    it "is false when there are no current appointments" do
      content_store_response["links"]["role_appointments"].each do |appointment|
        appointment["details"]["current"] = false
      end

      expect(person).not_to be_currently_in_a_role
    end
  end

  describe "#previous_non_ministerial_role_appointments" do
    it "excludes ministerial roles and returns the most recent first" do
      older_role = role_appointment(
        title: "Senior Auror",
        current: false,
        order: 5,
        started_on: "2010-01-01T00:00:00+00:00",
        ended_on: "2012-01-01T00:00:00+00:00",
        base_path: "/government/ministers/senior-auror",
        document_type: "role",
      )
      content_store_response["links"]["role_appointments"] << older_role

      expect(person.previous_non_ministerial_role_appointments.map { |appointment| appointment.role.title }).to eq([
        "Director of Magical Security",
        "Senior Auror",
      ])
    end

    it "does not include appointments that have not ended" do
      content_store_response["links"]["role_appointments"] << role_appointment(
        title: "Permanent Secretary",
        current: false,
        order: 5,
        started_on: "2018-01-01T00:00:00+00:00",
        base_path: "/government/ministers/permanent-secretary",
        document_type: "role",
      )

      expect(person.previous_non_ministerial_role_appointments.map { |appointment| appointment.role.title })
        .not_to include("Permanent Secretary")
    end
  end

  describe "#has_previous_non_ministerial_roles?" do
    it "is true when an ended non-ministerial appointment exists" do
      expect(person).to have_previous_non_ministerial_roles
    end
  end

  describe "#image_url" do
    it "returns the image URL" do
      expect(person.image_url).to eq("https://assets.publishing.service.gov.uk/rufus.jpg")
    end

    it "returns nil without an image" do
      content_store_response["details"].delete("image")

      expect(person.image_url).to be_nil
    end
  end

  describe "#slug" do
    it "returns the final part of the base path" do
      expect(person.slug).to eq("rufus-scrimgeour")
    end
  end

  def role_appointment(title:, current:, order:, base_path:, document_type:, started_on: nil, ended_on: nil)
    {
      "details" => {
        "current" => current,
        "person_appointment_order" => order,
        "started_on" => started_on,
        "ended_on" => ended_on,
      },
      "links" => {
        "role" => [
          {
            "title" => title,
            "base_path" => base_path,
            "document_type" => document_type,
            "details" => { "body" => "<p>Protects the magical community.</p>" },
            "links" => {
              "ordered_parent_organisations" => [
                {
                  "title" => "Ministry of Magic",
                  "base_path" => "/government/organisations/ministry-of-magic",
                },
              ],
            },
          },
        ],
      },
    }
  end
end
