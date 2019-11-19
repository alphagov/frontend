require "spec_helper"

RSpec.describe MandatoryFieldHelper, type: :helper do
  context "#validate_mandatory_text_fields" do
    it "returns an array of mandatory text field not populated" do
      session["full_name"] = ""
      session["job_title"] = "text"
      invalid_fields = validate_mandatory_text_fields(%w[full_name job_title], "contact_information")
      expect(invalid_fields).to eq [{ text: "Enter Full name" }]
    end
  end

  context "#validate_date_fields" do
    it "returns an error if year is blank" do
      invalid_fields = validate_date_fields("", "6", "25", "Date")
      expect(invalid_fields).to eq [{ text: "Date must include a year" }]
    end

    it "returns an error if month is blank" do
      invalid_fields = validate_date_fields("1990", "", "25", "Date")
      expect(invalid_fields).to eq [{ text: "Date must include a month" }]
    end

    it "returns an error if day is blank" do
      invalid_fields = validate_date_fields("1990", "6", "", "Date")
      expect(invalid_fields).to eq [{ text: "Date must include a day" }]
    end

    it "returns multiple errors if multiple date fields are blank" do
      invalid_fields = validate_date_fields("", "", "", "Date")
      expect(invalid_fields).to eq [
        { text: "Date must include a year" },
        { text: "Date must include a month" },
        { text: "Date must include a day" },
      ]
    end

    it "returns an error if date is not valid" do
      invalid_fields = validate_date_fields("2019", "02", "30", "Date")
      expect(invalid_fields).to eq [{ text: "Enter a real Date" }]
    end
  end

  context "#validate_radio_field" do
    it "return an error if no radio button selected" do
      invalid_fields = validate_radio_field("organisation_type", radio: "", other: "")
      expect(invalid_fields).to eq [{ text: "Select Organisation type" }]
    end

    it "returns an error when Other selected but no custom text entered" do
      invalid_fields = validate_radio_field("organisation_type", radio: "Other", other: "")
      expect(invalid_fields).to eq [{ text: "Enter Organisation type" }]
    end
  end
end
