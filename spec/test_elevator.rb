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
    @elevator = Elevator.new(building: @building, elev_num: 1)
    @building.build_elevators(elevators: [@elevator])
  end

  # Elevator starts on bottom floor
  def test_default__floor
    assert_equal 1, @elevator.current_floor
  end

  def test_move

    # Test going up one floor
    orig_pos = @elevator.current_floor
    assert_equal 1, orig_pos
    @building.floors[2].add_person Person.new(desired_floor: 1)
    assert_equal 1, @building.floors[2].count_line
    @elevator.moving_direction = :up
    @elevator.move
    assert_equal 2, @elevator.current_floor

    # Test going down one floor
    @elevator.moving_direction = :down
    @elevator.move
    assert_equal orig_pos, @elevator.current_floor

  end

  def test_bottom_floor_move
    # Test unable to go below bottom floor
    # elevator doesn't move if command is sent when on bottom floor
    @elevator.moving_direction = :down
    assert_equal 1, @elevator.current_floor
    @elevator.move
    assert_equal 1, @elevator.current_floor
    assert_equal :stopped, @elevator.moving_direction
  end

  def test_top_floor_move
    @building.floors[3].add_person Person.new(desired_floor: 1)
    # Test unable to go above top floor
    # elevator moves down if move command is sent when on top floor
    @elevator.moving_direction = :up
    (@elevator.current_floor...@elevator.max_floors).each { |_| @elevator.move }
    assert_equal 3, @elevator.current_floor
    @elevator.move
    assert_equal :down, @elevator.moving_direction
    assert_equal 2, @elevator.current_floor
  end

  def test_board
    @building.floor(1).add_person Person.new(desired_floor: 2)
    @elevator.moving_direction = :up
    assert_equal 1, @building.floor(1).count_line
    @elevator.board @building.floor(1)

    assert_equal 1, @elevator.passenger_count
    assert_equal 0, @building.floor(1).count_line
  end

  def test_exit_elevator
    @elevator.board_person Person.new(desired_floor: 1)
    assert_equal 1, @elevator.passenger_count
    @elevator.exit_elevator # elevator is on floor 1

    assert_equal 0, @elevator.passenger_count
  end

  def test_start_turn
    assert_equal :stopped, @elevator.moving_direction
    @building.floor(@elevator.current_floor).add_person Person.new(desired_floor: 3)

    @elevator.start_turn
    assert_equal 1, @elevator.passenger_count

    @elevator.start_turn # elevator gets to 3rd floor
    assert_equal 0, @elevator.passenger_count
  end

  def test_get_passengers
    assert_equal [], @elevator.get_passengers
    person1 = Person.new desired_floor: 2
    person2 = Person.new desired_floor: 2
    @elevator.board_person person1
    @elevator.board_person person2
    assert_equal [person1, person2], @elevator.get_passengers
  end

  # def test_to_s
  #   @elevator.board_person Person.new(desired_floor: 3)
  #   @elevator.move
  #   puts @elevator.to_s
  # end

end