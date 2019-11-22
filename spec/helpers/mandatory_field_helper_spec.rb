require "spec_helper"

RSpec.describe MandatoryFieldHelper, type: :helper do
  context "#validate_mandatory_text_fields" do
    it "returns an array of mandatory text field not populated" do
      session["full_name"] = ""
      session["job_title"] = "text"
      invalid_fields = validate_mandatory_text_fields(%w[full_name job_title], "contact_information")
      expect(invalid_fields).to eq [{ field: "full_name", text: "Enter full name" }]
    end

    it "returns a custom error when email address not populated" do
      session["email_address"] = ""
      invalid_fields = validate_mandatory_text_fields(%w[email_address], "contact_information")
      expect(invalid_fields).to eq [{ field: "email_address", text: "Enter email address in the correct format, like name@example.com" }]
    end

    it "returns a custom error when postcode not populated" do
      session["address_postcode"] = ""
      invalid_fields = validate_mandatory_text_fields(%w[address_postcode], "organisation_details")
      expect(invalid_fields).to eq [{ field: "address_postcode", text: "Enter a real postcode" }]
    end
  end

  context "#validate_date_fields" do
    it "returns an error if year is blank" do
      invalid_fields = validate_date_fields("", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date", text: "Date must include a year" }]
    end

    it "returns an error if month is blank" do
      invalid_fields = validate_date_fields("1990", "", "25", "date")
      expect(invalid_fields).to eq [{ field: "date", text: "Date must include a month" }]
    end

    it "returns an error if day is blank" do
      invalid_fields = validate_date_fields("1990", "6", "", "date")
      expect(invalid_fields).to eq [{ field: "date", text: "Date must include a day" }]
    end

    it "does not return an error if no date is entered" do
      invalid_fields = validate_date_fields("", "", "", "date")
      expect(invalid_fields).to eq []
    end

    it "returns multiple errors if multiple date fields are blank" do
      invalid_fields = validate_date_fields("", "", "25", "date")
      expect(invalid_fields).to eq [
        { field: "date", text: "Date must include a year" },
        { field: "date", text: "Date must include a month" },
      ]
    end

    it "returns an error if date is not valid" do
      invalid_fields = validate_date_fields("2019", "02", "30", "date")
      expect(invalid_fields).to eq [{ field: "date", text: "Enter a real date" }]
    end
  end

  context "#validate_radio_field" do
    it "return an error if no radio button selected" do
      invalid_fields = validate_radio_field("organisation_type", radio: "", other: "")
      expect(invalid_fields).to eq [{ field: "organisation_type", text: "Select organisation type" }]
    end

    it "returns an error when Other selected but no custom text entered" do
      invalid_fields = validate_radio_field("organisation_type", radio: "Other", other: "")
      expect(invalid_fields).to eq [{ field: "organisation_type", text: "Enter organisation type" }]
    end

    it "returns a custom error when companies house radio buttons not selected" do
      invalid_fields = validate_radio_field("companies_house_or_charity_commission_number", radio: "", other: "")
      expect(invalid_fields).to eq [{ field: "companies_house_or_charity_commission_number", text: "Select yes if you have a Companies House or Charity Commission number" }]
    end

    it "returns a custom error when companies house yes is selected but no value entered" do
      invalid_fields = validate_radio_field("companies_house_or_charity_commission_number", radio: "Yes", other: "")
      expect(invalid_fields).to eq [{ field: "companies_house_or_charity_commission_number", text: "Enter Companies House or Charity Commission number" }]
    end

    it "returns a custom error when grant number radio buttons not selected" do
      invalid_fields = validate_radio_field("grant_agreement_number", radio: "", other: "")
      expect(invalid_fields).to eq [{ field: "grant_agreement_number", text: "Select yes if you have a grant agreement number" }]
    end

    it "returns a custom error when grant number yes is selected but no value entered" do
      invalid_fields = validate_radio_field("grant_agreement_number", radio: "Yes", other: "")
      expect(invalid_fields).to eq [{ field: "grant_agreement_number", text: "Enter grant agreement number" }]
    end

    it "returns a custom error when programme radio buttons not selected" do
      invalid_fields = validate_radio_field("programme_funding", radio: "", other: "")
      expect(invalid_fields).to eq [{ field: "programme_funding", text: "Select what programme you receive funding from" }]
    end

    it "returns a custom error when outside UK participants radio buttons not selected" do
      invalid_fields = validate_radio_field("outside_uk_participants", radio: "", other: "")
      expect(invalid_fields).to eq [{ field: "outside_uk_participants", text: "Select yes if the project has partners or participants outside the UK" }]
    end
  end

  context "#validate_date_order" do
    it "returns an error when end date is before start date" do
      invalid_fields = validate_date_order("2019-11-19", "2019-11-18", "date")
      expect(invalid_fields).to eq [{ field: "date", text: "The end date must be after the start date" }]
    end

    it "does not return an error when end date is after start date" do
      invalid_fields = validate_date_order("2019-11-19", "2019-11-20", "date")
      expect(invalid_fields).to eq []
    end
  end

  context "#validate_email_address" do
    it "returns an error when email address doesn't contain @" do
      invalid_fields = validate_email_address("email", "john.doe2email.com")
      expect(invalid_fields).to eq [{ field: "email", text: "Enter email address in the correct format, like name@example.com" }]
    end

    it "does not return an error when email address contains @" do
      invalid_fields = validate_email_address("email", "john.doe@email.com")
      expect(invalid_fields).to eq []
    end
  end

  context "#validate_postcode" do
    it "returns an error when postcode is not valid" do
      invalid_fields = validate_postcode("postcode", "12A45")
      expect(invalid_fields).to eq [{ field: "postcode", text: "Enter a real postcode" }]
    end

    it "does not return an error when postcode is valid" do
      invalid_fields = validate_postcode("postcode", "e18QS")
      expect(invalid_fields).to eq []
    end
  end
end
