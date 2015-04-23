require_relative 'spec_helper'

require_rel '../lib/floor'

class TestFloor < Minitest::Test

  def setup
    @floor = Floor.new position: 6
  end

  def test_initialization
    assert_instance_of Floor, @floor
  end

end