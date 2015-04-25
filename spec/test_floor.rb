require_relative 'spec_helper'

require_relative '../lib/floor'

class TestFloor < Minitest::Test

  def setup
    @floor = Floor.new position: 6
  end


  def test_floor_num
    assert_equal 6, @floor.floor_num
  end

  def test_add_person
    orig_people = 0
    @floor.persons.values.each { |array| array.each {|_| orig_people += 1 } }
    @floor.add_person Person.new({desired_floor: 3})
    cur_people = 0
    @floor.persons.values.each { |array| array.each {|_| cur_people+= 1 } }
    assert_equal orig_people + 1, cur_people
  end

end