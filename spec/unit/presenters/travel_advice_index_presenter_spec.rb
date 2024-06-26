RSpec.describe TravelAdviceIndexPresenter, type: :model do
  context "handling countries" do
    before do
      attributes = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
      @presenter = TravelAdviceIndexPresenter.new(attributes)
    end

    it "sets the index attributes correctly" do
      expect(@presenter.subscription_url).to eq("/foreign-travel-advice/email-signup")
      expect(@presenter.description).to eq("Latest travel advice by country including safety and security, entry requirements, travel warnings and health")
      expect(@presenter.slug).to eq("foreign-travel-advice")
      expect(@presenter.title).to eq("Foreign travel advice")
    end

    it "sets the country attributes correctly" do
      country = @presenter.countries.first
      expect(country.change_description).to eq("Latest update: Summary - on 26 October 2015 a serious earthquake struck causing casualties around the country and affecting communications networks; if someone you know is likely to have been involved and you're unable to contact them, contact the British Embassy in Kabul")
      expect(country.name).to eq("Afghanistan")
      expect(country.title).to eq("Afghanistan")
      expect(country.synonyms).to eq([])
      expect(country.web_url).to eq("http://www.dev.gov.uk/foreign-travel-advice/afghanistan")
      expect(country.identifier).to eq("afghanistan")
      expect(country.updated_at).to eq(Time.zone.parse("2015-01-01"))
    end
    it "constructs a feed id for each country using the url and time format" do
      country = @presenter.countries.first
      expect(country.feed_id).to eq("http://www.dev.gov.uk/foreign-travel-advice/afghanistan#2015-01-01T00:00:00+00:00")
    end

    describe "#countries" do
      it "returns the countries in utf-8 order" do
        names = @presenter.countries.map(&:name)
        expect(names).to eq(["Afghanistan", "Austria", "Finland", "India", "Malaysia", "S\u00E3o Tom\u00E9 and Principe", "Spain"])
      end
    end

    describe "#countries_by_date" do
      it "returns the countries, ordered by updated_at descending" do
        names = @presenter.countries_by_date.map(&:name)
        expect(names).to eq(["S\u00E3o Tom\u00E9 and Principe", "Spain", "Malaysia", "India", "Finland", "Austria", "Afghanistan"])
      end
    end

    describe "#countries_recently_updated" do
      it "returns the 5 most recently updated countries" do
        names = @presenter.countries_recently_updated.map(&:name)
        expect(names).to eq(["S\u00E3o Tom\u00E9 and Principe", "Spain", "Malaysia", "India", "Finland"])
      end
    end

    describe "#countries_grouped_by_initial_letter" do
      before do
        attributes = { "base_path" => "/travel-advice", "details" => { "email_signup_link" => "/email/travel-advice" }, "description" => "countries", "title" => "Travel Advice", "links" => { "children" => [{ "base_path" => "/c", "details" => { "country" => { "name" => "Georgia" }, "change_description" => "xx" } }, { "base_path" => "/d", "details" => { "country" => { "name" => "The Gambia" }, "change_description" => "xx" } }, { "base_path" => "/a", "details" => { "country" => { "name" => "Peru" }, "change_description" => "xx" } }, { "base_path" => "/b", "details" => { "country" => { "name" => "The Occupied Palestinian Territories" }, "change_description" => "xx" } }] } }
        presenter = TravelAdviceIndexPresenter.new(attributes)
        @result = presenter.countries_grouped_by_initial_letter
      end

      it "orders initials alphabetically" do
        expect(@result.map(&:first)).to eq(%w[G P])
      end

      it "orders countries alphabetically ignoring definite article" do
        g_countries, = @result.map(&:second)
        expect(g_countries.map(&:name)).to eq(["The Gambia", "Georgia"])
      end

      it "orders countries using exceptional ordering rules" do
        _, p_countries = @result.map(&:second)
        expect(p_countries.map(&:name)).to eq(["The Occupied Palestinian Territories", "Peru"])
      end
    end
  end
end
