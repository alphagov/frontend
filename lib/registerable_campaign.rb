require 'ostruct'

# Takes a path and produces a campaign object for registering in
# panopticon
class RegisterableCampaign
  extend Forwardable

  attr_accessor :campaign, :live

  def_delegators :@campaign, :title, :need_id, :description, :slug

  def initialize(details)
    @campaign = OpenStruct.new(details)
  end

  def state
    'draft' # not to be displayed in search
  end

  def paths
    ["#{slug}"]
  end

  def prefixes
    [ ]
  end
end
