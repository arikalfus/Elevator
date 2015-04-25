require_relative 'spec_helper'

require_relative '../lib/elevator'
require_relative '../lib/floor'

class TestElevator < Minitest::Test

  def setup
    @elevator = Elevator.new floors: {1 => Floor.new(position: 1), 2=> Floor.new(position: 2), 3 => Floor.new(position: 3)}
  end

  def test_current_floor
    assert_equal 1, @elevator.current_floor.floor_num
  end

  def test_go_to_floor

    current_floor = @elevator.current_floor
    if current_floor.floor_num == 2
      floor = @elevator.go_to_floor 2
      assert_nil floor
      floor = @elevator.go_to_floor 1
      assert_equal Floor.new(position: 1), floor
    elsif current_floor.floor_num == 1
      floor = @elevator.go_to_floor 1
      assert_nil floor
      floor = @elevator.go_to_floor 2
      assert_equal Floor.new(position: 2), floor
    elsif current_floor.floor_num == 3
      floor = @elevator.go_to_floor 3
      assert_nil floor
      floor = @elevator.go_to_floor 2
      assert_equal Floor.new(position: 2), floor
    else
      raise Exception, "Current floor is an invalid number: #{current_floor}. Something went wrong."
    end

  end

  def test_move
    orig_pos = @elevator.current_floor.floor_num
    @elevator.moving_direction = :stopped
    @elevator.move # when stopped, elevator should do nothing
    assert_equal orig_pos, @elevator.current_floor.floor_num

    # Test going up one floor
    new_pos = orig_pos + 1
    @elevator.moving_direction = :up
    assert_equal :up, @elevator.moving_direction
    @elevator.move
    assert_equal new_pos, @elevator.current_floor.floor_num

    # Test going down one floor
    @elevator.moving_direction = :down
    @elevator.move
    assert_equal orig_pos, @elevator.current_floor.floor_num

  end

  def test_start_turn
    assert_equal :stopped, @elevator.moving_direction

  end

end