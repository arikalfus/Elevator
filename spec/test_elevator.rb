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

end