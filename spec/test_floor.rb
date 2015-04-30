require_relative 'spec_helper'

require_relative '../lib/floor'
require_relative '../lib/building'
require_relative '../lib/elevator'

class TestFloor < Minitest::Test

  def setup
    @building = Building.new
    @floor = Floor.new(position: 3, building: @building)
    @building.build_floors(floors: { 1 => Floor.new(position: 1, building: @building), 2 => Floor.new(position: 2, building: @building),
                                     3 => @floor})
    @elevator = Elevator.new(building: @building)
    @building.build_elevators(elevators: [@elevator])
  end


  def test_floor_num
    assert_equal 3, @floor.position
  end

  def test_add_person
    orig_people = @floor.count_line
    @floor.add_person Person.new({desired_floor: 1})
    cur_people = @floor.count_line
    assert_equal orig_people + 1, cur_people
  end

  def test_comparable
    new_floor = Floor.new position: 3
    assert_equal 0, new_floor <=> @floor

    another_floor = Floor.new position: 10
    assert_equal 1, another_floor <=> @floor

    last_floor = Floor.new position: 1
    assert_equal -1, last_floor <=> @floor

    assert_equal @floor, new_floor
  end

  def test_boarding
    person1 = Person.new({desired_floor: 1})
    person2 = Person.new({desired_floor: 1})
    @floor.add_person person1
    @floor.add_person person2
    assert_equal 2, @floor.count_line
    @elevator.board @floor

    assert_equal [person1, person2], @elevator.get_passengers
    people_on_floor = floor.count_line
    assert_equal 0, people_on_floor
  end

  def test_arriving
    floor = Floor.new(position: 1, building: @building)
    floor.arrive([Person.new(desired_floor: 2), Person.new(desired_floor: 2)])
    assert_equal 2, floor.count_line

    @elevator.move
    assert_equal 0, floor.count_line
    assert_equal 2, @elevator.count_passengers
  end

end