require 'set'

class Building

  attr_reader :elevators, :floors, :pickup_requests

  def initialize
    @floors = Hash.new
    @elevators = Array.new
    @pickup_requests = Set.new
  end

  def add_floors(params)
    @floors = params[:floors]
  end

  def add_elevators(params)
    @elevators = params[:elevators]
  end

  # Return number of elevators in building, or an exception if building has not been properly initialized
  def number_of_elevators
    elevators.nil? ? raise(Exception,'No elevators exist! You should run the #build_elevators method.') : elevators.count
  end

  # Return number of floors in building, or an exception if building has not been properly initialized
  def number_of_floors
    floors.nil? ? raise(Exception, 'No floors exist! You should run the #build_floors method.') : floors.keys.count
  end

  # Run each elevator for one turn
  def start_turn
    # # Redundancy check: log pickup requests if floor has waiting passengers
    # floors.values.each { |floor| log_pickup_request(floor.position) if floor.waiting_count > 0 }
    # Run each elevator
    elevators.each { |elevator| elevator.start_turn }
  end

  # Returns floor object corresponding to floor number
  def floor(num)
    floors[num]
  end

  # Adds a pickup request to the Set of requests
  def log_pickup_request(floor_num)
    @pickup_requests.add floor_num
  end

  # Returns an array of all current pickup requests
  def get_all_pickup_requests
    pickup_requests.to_a
  end

  # Returns a boolean referring to whether there are pickup requests above the floor_num
  def check_pickup_requests(floor_num)

    nums = Array.new
    total_floors = floors.keys.count

    (floor_num..total_floors).each do |floor|
        return true if pickup_requests.include? floor
    end

    false

  end

  # Deletes a pickup request from the Set of requests, indicating no more people on that floor need to be picked up
  def remove_pickup_request(floor_num)
    pickup_requests.delete floor_num
  end

  # Displays helpful details about the Building's current state
  def to_s
    %Q(
    Building stats:
      Number of floors: #{number_of_floors}
      Number of elevators: #{number_of_elevators}
    )
  end

end