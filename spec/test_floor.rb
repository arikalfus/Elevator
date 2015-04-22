require_relative 'spec_helper'

require_relative '../lib/floor'

class TestFloor < Minitest::Test

  def setup
    @floor = Floor.new(
                      position: 6,
                      buttons: [['up', 'down'], ['up', 'down']]
    )
  end

  def test_initialization
    assert_instance_of Floor, @floor
  end

  def test_number_of_elevators
    elevator_count = @floor.number_of_elevators
    assert_equal 2, elevator_count
  end

end