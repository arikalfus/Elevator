require_relative 'spec_helper'

require_relative '../lib/elevator'
require_relative '../lib/floor'

class TestElevator < Minitest::Test

  def setup
    @elevator = Elevator.new(floors: [Floor.new(
                                              position: 1,
                                              buttons: [['up', 'down']]
                                     ),
                                     Floor.new(
                                              position: 2,
                                              buttons: [['up', 'down']]
                                     )])
  end

  def test_initialization
    assert_instance_of Elevator, @elevator
  end

  def test_current_floor
    assert_includes [1, 2], @elevator.current_floor
  end

  def test_go_to_floor
    current_floor = @elevator.current_floor
    if current_floor == 2
      floor = @elevator.go_to_floor 2
      assert_nil floor
      floor = @elevator.go_to_floor 1
      assert_equal Floor.new(position: 1, buttons: [['up', 'down']]), floor
    elsif current_floor == 1
      floor = @elevator.go_to_floor 1
      assert_nil floor
      floor = @elevator.go_to_floor 2
      assert_equal Floor.new(position: 2, buttons: [['up', 'down']]), floor
    else
      raise Exception, "Current floor is an invalid number: #{current_floor}"
    end

  end

end