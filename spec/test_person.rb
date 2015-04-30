require_relative 'spec_helper'

require_relative '../lib/person'

class TestPerson < Minitest::Test

  def setup
    @person = Person.new({desired_floor: 1})
  end

  def test_desire
    assert_instance_of Fixnum, @person.desired_floor
  end

end