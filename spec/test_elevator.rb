require_relative 'spec_helper'

require_relative '../lib/elevator'
require_relative '../lib/building'
require_relative '../lib/floor'

class TestElevator < Minitest::Test

  def setup
    @building = Building.new
    @building.build_floors(floors: { 1 => Floor.new(position: 1, building: @building),
                                     2 => Floor.new(position: 2, building: @building),
                                     3 => Floor.new(position: 3, building: @building)})
    @elevator = Elevator.new building: @building
    @building.build_elevators(elevators: [@elevator])
  end

  # Elevator starts on bottom floor
  def test_default__floor
    assert_equal 1, @elevator.current_floor
  end

  def test_go_to_floor

    current_floor = @elevator.current_floor
    @elevator.go_to_floor 1
    assert_equal current_floor, @elevator.current_floor
    @elevator.go_to_floor 2
    assert_equal 2, @elevator.current_floor
    # Elevator should not move if given an incorrect floor number
    @elevator.go_to_floor 6
    assert_equal 2, @elevator.current_floor

  end

  def test_move

    # Test going up one floor
    orig_pos = @elevator.current_floor
    @elevator.moving_direction = :up
    assert_equal :up, @elevator.moving_direction
    @elevator.move
    assert_equal orig_pos + 1, @elevator.current_floor

    # Test going down one floor
    @elevator.moving_direction = :down
    @elevator.move
    assert_equal orig_pos, @elevator.current_floor

    # Test unable to go below bottom floor
    # elevator moves up if move command is sent when on bottom floor
    @elevator.go_to_floor 1
    @elevator.moving_direction = :down
    assert_equal 1, @elevator.current_floor
    @elevator.move
    assert_equal 2, @elevator.current_floor
    assert_equal :up, @elevator.moving_direction

    # Test unable to go above top floor
    # elevator moves down if move command is sent when on top floor
    @elevator.go_to_floor @elevator.max_floors
    assert_equal 3, @elevator.current_floor
    @elevator.moving_direction = :up
    @elevator.move
    assert_equal 2, @elevator.current_floor
    assert_equal :down, @elevator.moving_direction

  end

  def test_start_turn
    assert_equal :stopped, @elevator.moving_direction
    floor = @elevator.building.floors[@elevator.current_floor]
    floor.add_person Person.new(desired_floor: 2)

    @elevator.start_turn
    assert_equal 1, @elevator.passengers.count
  end

end