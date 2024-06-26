RSpec.describe TransactionPresenter do
  def subject(content_item)
    described_class.new(content_item.deep_stringify_keys!)
  end

  context "details" do
    before do
      @item = {
        details: {
          introductory_paragraph: "foo",
          more_information: "bar",
          other_ways_to_apply: "carrots",
          transaction_start_link: "bananas",
          what_you_need_to_know: "hats",
          will_continue_on: "scarves",
          start_button_text: "Start now",
        },
      }
    end

    describe "#introductory_paragraph" do
      it "shows the introductory_paragraph" do
        expect(subject(@item).introductory_paragraph).to eq("foo")
      end
    end

    describe "#more_information" do
      it "shows the more_information" do
        expect(subject(@item).more_information).to eq("bar")
      end
    end

    describe "#other_ways_to_apply" do
      it "shows the other_ways_to_apply" do
        expect(subject(@item).other_ways_to_apply).to eq("carrots")
      end
    end

    describe "#transaction_start_link" do
      it "shows the transaction_start_link" do
        expect(subject(@item).transaction_start_link).to eq("bananas")
      end
    end

    describe "#what_you_need_to_know" do
      it "shows the what_you_need_to_know" do
        expect(subject(@item).what_you_need_to_know).to eq("hats")
      end
    end

    describe "#will_continue_on" do
      it "shows the will_continue_on" do
        expect(subject(@item).will_continue_on).to eq("scarves")
      end
    end

    context "start_button_text is 'Start now'" do
      describe "#start_button_text" do
        it "shows the start_button_text" do
          expect(subject(@item).start_button_text).to eq("Start now")
        end
      end
    end

    context "start_button_text is 'Sign in'" do
      describe "#start_button_text" do
        it "shows the custom start button text" do
          @item[:details][:start_button_text] = "Sign in"

          expect(subject(@item).start_button_text).to eq("Sign in")
        end
      end
    end
  end

  context "locale is 'cy'" do
    before do
      I18n.locale = :cy
      @item = { details: { start_button_text: "Start now" } }
    end
    after { I18n.locale = :en }

    context "start_button_text is 'Start now'" do
      it "returns Welsh translation 'Dechrau nawr'" do
        expect(subject(@item).start_button_text).to eq("Dechrau nawr")
      end
    end

    context "start_button_text is 'Sign in'" do
      it "returns Welsh translation 'Mewngofnodi'" do
        @item[:details][:start_button_text] = "Sign in"

        expect(subject(@item).start_button_text).to eq("Mewngofnodi")
      end
    end
  end

  describe "#multiple_more_information_sections?" do
    it "is false with no sections" do
      expect(subject({}).multiple_more_information_sections?).to be false
    end

    it "is false with only one section" do
      item = { details: { more_information: "carrots" } }

      expect(subject(item).multiple_more_information_sections?).to be false
    end

    it "is true if there are multiple sections" do
      item = { details: { more_information: "carrots", what_you_need_to_know: "all about carrots" } }

      expect(subject(item).multiple_more_information_sections?).to be true
    end

    it "shows the tab count for two tabs" do
      item = { details: { more_information: "potatoes", what_you_need_to_know: "all about potatoes" } }

      expect(2).to eq(subject(item).tab_count)
    end

    it "shows the tab count for three tabs" do
      item = {
        details: {
          more_information: "potatoes",
          what_you_need_to_know: "all about potatoes",
          other_ways_to_apply: "I just love potatoes",
        },
      }

      expect(3).to eq(subject(item).tab_count)
    end
  end
end
