require 'pry-byebug'

class Elevator

  ELEV_MAX_PERSONS = 20
  ELEV_RESTING_FLOOR = 1

  attr_reader :floors, :max_floors, :current_floor, :passengers
  attr_accessor :moving_direction

  def initialize(params)
    @floors = params[:floors]
    @max_floors = floors.keys.count
    @moving_direction = :stopped
    @current_floor = floors[1]
    @passengers = Array.new
  end

  def start_turn
    if @moving_direction == :stopped
      @moving_direction = :up
      move
    else
      move
    end
  end

  # Returns floor object unless desired floor is current position of elevator
  def go_to_floor(floor_num)
    if floor_num == current_floor.floor_num
      nil
    else
      floors[floor_num]
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

  # Passengers are inserted into passengers array ordered by what floor they want to get off at
  def board_person(person)
    passengers.push person
    # TODO: complete this method
  end

  private

  def move_up
    current_floor_num = current_floor.floor_num
    if current_floor_num + 1 == max_floors
      @moving_direction = :down
    end
    @current_floor = floors[current_floor_num + 1]
  end

  def move_down
    current_floor_num = current_floor.floor_num
    if current_floor_num - 1 == ELEV_RESTING_FLOOR
      @moving_direction = :stopped
    end
    @current_floor = floors[current_floor_num - 1]
  end

end