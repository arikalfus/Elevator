require_relative 'spec_helper'

require_relative '../lib/building'
require_relative '../lib/elevator'
require_relative '../lib/floor'

class TestBuilding < Minitest::Test

  def setup
    @building = Building.new(
                            elevators: [Elevator.new(floors: [Floor.new(position: 1, buttons: [['up', 'down']]), Floor.new(position: 2, buttons: [['up', 'down']])], current_floor: 1),
                                        Elevator.new(floors: [Floor.new(position: 1, buttons: [['up', 'down']]), Floor.new(position: 2, buttons: [['up', 'down']])])],
                            floors: [Floor.new(position: 1, buttons: [['up', 'down'], ['up', 'down']]), Floor.new(position: 2, buttons: [['up', 'down'], ['up', 'down']])], current_floor: 1)
  end

  def test_initialization
    assert_instance_of Building, @building
  end

  def test_counts
    assert_equal 2, @building.number_of_elevators
    assert_equal 2, @building.number_of_floors
  end

end