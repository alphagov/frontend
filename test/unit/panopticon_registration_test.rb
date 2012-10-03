require_relative '../test_helper'

require 'gds_api/panopticon'
require 'registerable_campaign'

class PanopticonRegistrationTest < ActiveSupport::TestCase
  context "Panopticon registration" do
    should "translate to Panopticon artefacts" do
      registerer = GdsApi::Panopticon::Registerer.new(owning_app: "frontend")

      campaign = RegisterableCampaign.new({
        :title => "Automatic enrolment into a workplace pension",
        :slug => "workplacepensions",
        :need_id => nil,
        :description => "Workplace pensions - what it means for you"
      })
      artefact = registerer.record_to_artefact(campaign)

      [:name, :description, :slug].each do |key|
        assert artefact.has_key?(key), "Missing attribute: #{key}"
        assert ! artefact[key].nil?, "Attribute #{key} is nil"
      end

      assert_equal ["workplacepensions"], artefact[:paths]
      assert_equal [], artefact[:prefixes]

      assert_equal 'draft', artefact[:state], "Is live"
    end
  end
end
