require 'pry-byebug'

class Elevator

  ELEV_MAX_PERSONS = 20
  ELEV_RESTING_FLOOR = 1

  attr_reader :building, :max_floors, :current_floor, :passengers
  attr_accessor :moving_direction

  def initialize(params)

    @building = params[:building]
    @max_floors = building.number_of_floors
    @moving_direction = :stopped
    @current_floor = ELEV_RESTING_FLOOR
    build_passenger_hash

  end

  def start_turn

    move
    # TODO: passengers exit the elevator

  end

  # Returns floor object unless desired floor is current position of elevator
  #
  # Only used for testing purposes -- no need in final design
  # TODO: Remove this method at the end
  def go_to_floor(floor_num)

    @current_floor = floor_num if floor_num >= ELEV_RESTING_FLOOR and floor_num <= max_floors

  end

  # Elevator moves up/down based on current moving_direction
  def move

    if moving_direction == :up
      if read_passenger_desires
        @moving_direction = :down
        move
      else
        move_up
      end
    elsif moving_direction == :down
      move_down
    elsif moving_direction == :stopped
      begin_moving
    else
      raise Exception, 'Moving direction is set to an invalid symbol:', moving_direction
    end

  end

  # Passengers from floor are boarded onto elevator
  def board(floor)

    boarded = 0

    unless moving_direction == :stopped
      waiting_line = floor.get_waiting moving_direction

      waiting_line.each do |person|
        unless passengers.count == ELEV_MAX_PERSONS
          board_person person
          boarded += 1
        end
      end

      floor.update_waiting_line boarded, moving_direction # update floor
    end

  end

  def exit_elevator(floor)
    persons_exiting = passengers[current_floor]
    @passengers[current_floor].clear
    floor.arrive persons_exiting
  end

  # Passengers are inserted into passengers array ordered by what floor they want to get off at
  def board_person(person)
    @passengers[person.desired_floor].push person
  end

  # Returns the number of passengers onboard the elevator.
  def count_passengers
    num = 0
    passengers.values.each {|array| array.each {|_| num += 1 } }
    num
  end

  # Returns passengers as an array
  def get_passengers
    passengers.values.flatten
  end

  private

  # Passengers are stored in a hash where each key is a floor number corresponding to an array of passengers desiring that floor
  def build_passenger_hash
    @passengers = Hash.new
    (1..@max_floors).each { |i| @passengers[i] = Array.new }
  end

  def move_up

    @moving_direction = :down if current_floor + 1 == max_floors

    if current_floor == max_floors
      @moving_direction = :down
      move
    else
      board building.floor(current_floor)
      @current_floor += 1
    end

  end

  def move_down

    @moving_direction = :stopped if current_floor - 1 == ELEV_RESTING_FLOOR

    if current_floor == ELEV_RESTING_FLOOR
      @moving_direction = :up
      move
    else
      board building.floor(current_floor)
      @current_floor -= 1
    end

  end

  # Method should only be called if elevator is at ELEV_RESTING_FLOOR
  def begin_moving
    raise Error, '#begin_moving was called somewhere other than ELEV_RESTING_FLOOR' unless current_floor == ELEV_RESTING_FLOOR
    @moving_direction = :up
    move
  end

  # Checks if any passengers want to get off on a higher floor
  def read_passenger_desires
    (current_floor..max_floors).each { |floor_num| check_desires floor_num }
    false # else, no more passengers to unload
  end

  # Checks if any passengers want to get off at floor floor_num
  def check_desires(floor_num)
    true unless passengers[floor_num].empty?
  end

end