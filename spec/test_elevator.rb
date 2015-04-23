require_relative 'spec_helper'

require_rel '../lib/elevator', '../lib/floor'

class TestElevator < Minitest::Test

  def setup
    @elevator = Elevator.new floors: {1 => Floor.new(position: 1), 2=> Floor.new(position: 2), 3 => Floor.new(position: 3)}
  end

  def test_initialization
    assert_instance_of Elevator, @elevator
  end

  def test_current_floor
    assert_equal 1, @elevator.current_floor
  end

  def test_go_to_floor
    current_floor = @elevator.current_floor
    if current_floor == 2
      floor = @elevator.go_to_floor 2
      assert_nil floor
      floor = @elevator.go_to_floor 1
      assert_equal Floor.new(position: 1), floor
    elsif current_floor == 1
      floor = @elevator.go_to_floor 1
      assert_nil floor
      floor = @elevator.go_to_floor 2
      assert_equal Floor.new(position: 2), floor
    elsif current_floor == 3
      floor = @elevator.go_to_floor 3
      assert_nil floor
      floor = @elevator.go_to_floor 2
      assert_equal Floor.new(position: 2), floor
    else
      raise Exception, "Current floor is an invalid number: #{current_floor}"
    end

  end

end