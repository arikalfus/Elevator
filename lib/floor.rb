require 'pry-byebug'

class Floor

  attr_reader :position, :persons

  def initialize(params)
    @position = params[:position] # int position from 1 to n
    @persons = params[:persons] || { up: [], down: [] } # hash of people waiting for an elevator, keys are up/down and values are arrays of Persons
  end

  # Board passengers onto an elevator and update queue
  def start_turn(elevator)

    direction = elevator.moving_direction
    num_boarded = board_elevator elevator
    update_waiting_line num_boarded, direction

  end

  # add Person object to this floor in the correct queue
  def add_person(person)
    current_position = position <=> person.desired_floor
    if current_position == 1 # person is above their desired floor
      persons[:down].push person
    elsif current_position == -1 # person is below their desired floor
      persons[:up].push person
    # else, person is on their desired floor, do nothing
    end
  end

  def floor_num
    position
  end

  # Floors are compared by their position number
  def <=>(other)
    position <=> other.position
  end

  def ==(other)
    position == other.position
  end

  private

  def board_elevator(elevator)
    elevator.board # current floor should be recorded in elevator, no need to pass this Floor to Elevator
  end

  # Remove Persons from appropriate queue after boarding an Elevator
  def update_waiting_line(num_boarded, direction)

    waiting_line = persons[direction]
    waiting_line.slice num_boarded
    persons[direction] = waiting_line

  end

end