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

    if @moving_direction == :stopped
      @moving_direction = :up
      move
      board building.floor[current_floor]
    else
      move
      board building.floor[current_floor]
    end

  end

  # Returns floor object unless desired floor is current position of elevator
  def go_to_floor(floor_num)

    if floor_num == current_floor
      nil
    else
      building.floors[floor_num]
    end

  end

  # Elevator moves up/down based on current moving_direction
  def move

    if moving_direction == :up
      move_up
    elsif moving_direction == :down
      move_down
    # if moving_direction is :stopped, do nothing
    end

  end

  def board(floor)

    boarded = 0
    waiting_line = floor.persons[moving_direction]
    waiting_line.each do |person|
      unless passengers.count == ELEV_MAX_PERSONS
        passengers.push person
        boarded += 1
      end
    end

    boarded

  end

  # Passengers are inserted into passengers array ordered by what floor they want to get off at
  def board_person(person)
    passengers.push person
    # TODO: complete this method
  end

  private

  def move_up

    if current_floor + 1 == max_floors
      @moving_direction = :down
    end
    @current_floor += 1

  end

  def move_down

    if current_floor - 1 == ELEV_RESTING_FLOOR
      @moving_direction = :stopped
    end
    @current_floor -= 1

  end

end