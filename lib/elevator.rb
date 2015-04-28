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
    @passengers = Array.new

  end

  def start_turn

    move
    # TODO: exit the elevator

  end

  # Returns floor object unless desired floor is current position of elevator
  #
  # Only used for testing purposes -- no need in final design
  # TODO: Remove this method at the end?
  def go_to_floor(floor_num)

    @current_floor = floor_num if floor_num >= ELEV_RESTING_FLOOR and floor_num <= max_floors

  end

  # Elevator moves up/down based on current moving_direction
  def move

    if moving_direction == :up
      move_up
    elsif moving_direction == :down
      move_down
    elsif moving_direction == :stopped
      begin_moving
    else
      raise Exception, 'Moving direction is set to an invalid symbol:', moving_direction
    end

  end

  def board(floor)

    boarded = 0

    unless moving_direction == :stopped
      waiting_line = floor.persons[moving_direction]

      waiting_line.each do |person|
        unless passengers.count == ELEV_MAX_PERSONS
          passengers.push person
          boarded += 1
        end
      end

      floor.board_elevator boarded, moving_direction
    end

  end

  # Passengers are inserted into passengers array ordered by what floor they want to get off at
  def board_person(person)
    passengers.push person
    # TODO: complete this method
  end

  private

  def move_up

    @moving_direction = :down if current_floor + 1 == max_floors

    if current_floor == max_floors
      @moving_direction = :down
      move
    else
      board building.floors[current_floor]
      @current_floor += 1
    end

  end

  def move_down

    @moving_direction = :stopped if current_floor - 1 == ELEV_RESTING_FLOOR

    if current_floor == ELEV_RESTING_FLOOR
      @moving_direction = :up
      move
    else
      board building.floors[current_floor]
      @current_floor -= 1
    end

  end

  # Method should only be called if elevator is at ELEV_RESTING_FLOOR
  def begin_moving
    @moving_direction = :up
    move
  end

end