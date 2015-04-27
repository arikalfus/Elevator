require_relative 'spec_helper'

require_relative '../lib/building'
require_relative '../lib/elevator'
require_relative '../lib/floor'

class TestBuilding < Minitest::Test

  def setup
    @building = Building.new
    @building.build_floors(floors: { 1 => Floor.new(position: 1, building: @building), 2 => Floor.new(position: 2, building: @building),
                                     3 => Floor.new(position: 3, building: @building)})
    @building.build_elevators(elevators: [Elevator.new(building: @building),
                                          Elevator.new(building: @building),
                                          Elevator.new(building: @building)])

  end

  def test_counts
    assert_equal 3, @building.number_of_elevators
    assert_equal 3, @building.number_of_floors
  end

end