require_relative 'spec_helper'

require_rel '../lib/building', '../lib/elevator', '../lib/floor'

class TestBuilding < Minitest::Test

  def setup
    @building = Building.new(
                            elevators: [Elevator.new(floors: { 1 => Floor.new(position: 1), 2 => Floor.new(position: 2), 3 => Floor.new(position: 3)}),
                                        Elevator.new(floors: { 1 => Floor.new(position: 1), 2 => Floor.new(position: 2), 3 => Floor.new(position: 3)}),
                                        Elevator.new(floors: { 1 => Floor.new(position: 1), 2 => Floor.new(position: 2), 3 => Floor.new(position: 3)})],
                            floors: { 1 => Floor.new(position: 1), 2 => Floor.new(position: 2), 3 => Floor.new(position: 3)})
  end

  def test_initialization
    assert_instance_of Building, @building
  end

  def test_counts
    assert_equal 3, @building.number_of_elevators
    assert_equal 3, @building.number_of_floors
  end

end