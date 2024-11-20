module MissionTypeHelper
  def self.style(mission_type)
    valid_numbers = (1..6)
    return "mission-1" unless valid_numbers.include?(mission_type)

    "mission-#{mission_type}"
  end
end
