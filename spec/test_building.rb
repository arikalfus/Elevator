require_relative 'spec_helper'

require_relative '../lib/building'
require_relative '../lib/elevator'
require_relative '../lib/floor'

class TestBuilding < Minitest::Test

  def setup
    @building = Building.new
    @building.add_floors(floors: { 1 => Floor.new(position: 1, building: @building), 2 => Floor.new(position: 2,
                                                                                                  building: @building),
                                     3 => Floor.new(position: 3, building: @building)})
    @building.add_elevators(elevators: [Elevator.new(building: @building, elev_num: 1),
                                          Elevator.new(building: @building, elev_num: 2),
                                          Elevator.new(building: @building, elev_num: 3)])

  end

  def test_counts
    assert_equal 3, @building.number_of_elevators
    assert_equal 3, @building.number_of_floors
  end

  def test_floor
    floor = @building.floor 1
    assert_equal floor, Floor.new(position: 1, building: @building) # floors are compared by position number
  end

  def test_log_pickup_request
    assert_equal 0, @building.get_all_pickup_requests.count
    @building.log_pickup_request 2
    assert_equal 1, @building.get_all_pickup_requests.count
  end

  def test_get_all_pickup_requests
    assert_equal [], @building.get_all_pickup_requests
    @building.log_pickup_request 3
    assert_equal [3], @building.get_all_pickup_requests
  end

  def check_pickup_requests
    @building.log_pickup_request 3
    requests = @building.check_pickup_requests 1
    assert_equal true, requests

    requests2 = @building.check_pickup_requests 3
    assert_equal false, requests2

    requests3 = @building.check_pickup_requests 5
    assert_equal false, requests3
  end

  def test_delete_pickup_request
    assert_equal [], @building.get_all_pickup_requests
    @building.log_pickup_request 2
    assert_equal [2], @building.get_all_pickup_requests
    @building.remove_pickup_request 2
    assert_equal [], @building.get_all_pickup_requests
  end

  # def test_to_s
  #   puts @building.to_s
  # end

end