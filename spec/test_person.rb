require_relative 'spec_helper'

require_rel '../lib/person'

class TestPerson < Minitest::Test

  def setup
    @person = Person.new({desired_floor: 1})
  end

  def test_initialization
    assert_instance_of Person, @person
  end

end