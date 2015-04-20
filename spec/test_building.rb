require_relative 'spec_helper'

require_relative '../lib/building'
require_relative '../lib/elevator'
require_relative '../lib/floor'

class TestBuilding < Minitest::Test

  def setup
    @building = Building.new(
                            elevators: [Elevator.new(floors: [Floor.new(position: 1, buttons: [['up', 'down']]), Floor.new(position: 2, buttons: [['up', 'down']])]),
                                        Elevator.new(floors: [Floor.new(position: 1, buttons: [['up', 'down']]), Floor.new(position: 2, buttons: [['up', 'down']])])],
                            floors: [Floor.new(position: 1, buttons: [['up', 'down'], ['up', 'down']]), Floor.new(position: 2, buttons: [['up', 'down'], ['up', 'down']])])
  end

  def test_initialization
    assert_instance_of Building, @building
  end

  def test_counts
    assert_equal 2, @building.number_of_elevators
    assert_equal 2, @building.number_of_floors
  end

end