require_relative 'spec_helper'

require_relative '../lib/floor'
require_relative '../lib/building'
require_relative '../lib/elevator'

class TestFloor < Minitest::Test

  def setup
    @building = Building.new
    @floor = Floor.new(position: 6, building: @building)
    @building.build_floors(floors: { 1 => Floor.new(position: 1, building: @building), 2 => Floor.new(position: 2, building: @building),
                                     6 => @floor})
    @elevator = Elevator.new(building: @building)
    @building.build_elevators(elevators: [@elevator])
  end


  def test_floor_num
    assert_equal 6, @floor.position
  end

  def test_add_person
    orig_people = 0
    @floor.persons.values.each { |array| array.each {|_| orig_people += 1 } }
    @floor.add_person Person.new({desired_floor: 3})
    cur_people = 0
    @floor.persons.values.each { |array| array.each {|_| cur_people += 1 } }
    assert_equal orig_people + 1, cur_people
  end

  def test_comparable
    new_floor = Floor.new position: 3
    assert_equal -1, new_floor <=> @floor

    another_floor = Floor.new position: 10
    assert_equal 1, another_floor <=> @floor

    last_floor = Floor.new position: 6
    assert_equal 0, last_floor <=> @floor

    assert_equal @floor, last_floor
  end

  def test_boarding
    @elevator.go_to_floor 6
    @elevator.moving_direction = :down
    person1 = Person.new({desired_floor: 1})
    person2 = Person.new({desired_floor: 1})
    @floor.add_person person1
    @floor.add_person person2
    num_boarded = @elevator.board @floor
    @floor.update_waiting_line num_boarded, @elevator.moving_direction
    assert_equal [person1, person2], @elevator.passengers
    people_on_floor = 0
    @floor.persons.values.each{ |array| array.each { |_| people_on_floor += 1 }

    assert_equal 0, people_on_floor}
  end

end